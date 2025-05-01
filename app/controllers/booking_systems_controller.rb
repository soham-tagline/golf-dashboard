class BookingSystemsController < ApplicationController

  def analytics
    problematic_booking_system
    scraper_latency_by_booking_system

    respond_to do |format|
      format.html
    end
  end

  private

  def problematic_booking_system
    @data = ScrapeError
            .joins(scrape_event: :course)
            .group(Arel.sql('courses.booking_system'))
            .order(Arel.sql('COUNT(*) DESC'))
            .count
  end

  def scraper_latency_by_booking_system
    @average_durations = ScrapeEvent
                        .joins(:course)
                        .where.not(scrape_start: nil, scrape_end: nil)
                        .group('courses.booking_system')
                        .pluck(
                          'courses.booking_system',
                          Arel.sql('AVG((julianday(scrape_end) - julianday(scrape_start)) * 86400.0)')
                        )
                        .sort_by { |_system, avg_duration| -avg_duration.to_f }
  end

  def scrape_volume_by_booking_system
    @booking_systems = Course.distinct.pluck(:booking_system).compact.sort
    @selected_system = params[:booking_system] || 'ALL'
    @date_range = params[:date_range] || '7d'
    @start_date = params[:start_date]
    @end_date = params[:end_date]

    @scrape_volume = ScrapeEvent
      .joins(:course)
      .where(has_error: false)
      .where(booking_system_filter)
      .where(date_filter)
      .group('DATE(scrape_start)')
      .order('DATE(scrape_start) ASC')
      .select(
        'DATE(scrape_start) as scrape_date',
        'COUNT(*) as success_count'
      )
  end

  def booking_system_filter
    return {} if @selected_system == 'ALL'
    { 'courses.booking_system' => @selected_system }
  end

  def date_filter
    case @date_range
    when '7d' then { scrape_start: 7.days.ago..Time.current }
    when '30d' then { scrape_start: 30.days.ago..Time.current }
    when 'custom'
      start = @start_date.present? ? Date.parse(@start_date) : 7.days.ago
      end_date = @end_date.present? ? Date.parse(@end_date) : Time.current
      { scrape_start: start..end_date }
    else
      { scrape_start: 7.days.ago..Time.current }
    end
  end
end