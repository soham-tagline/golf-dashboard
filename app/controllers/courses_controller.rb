class  CoursesController < ApplicationController

  def analytics
    problematic_courses
    scraper_latency_by_course
    scrape_volume_by_course

    respond_to do |format|
      format.html
    end
  end

  private


  def problematic_courses
    @problematic_courses = ScrapeError
      .joins(scrape_event: :course)
      .group('courses.id', 'courses.name')
      .order('COUNT(scrape_errors.id) DESC')
      .select(
        'courses.name as course_name',
        'COUNT(scrape_errors.id) as error_count'
      )
  end

  def scraper_latency_by_course
    @latency_data = ScrapeEvent
      .joins(:course)
      .where.not(scrape_start: nil, scrape_end: nil)
      .group('courses.id', 'courses.name')
      .select(
        'courses.name as course_name',
        'AVG((julianday(scrape_end) - julianday(scrape_start)) * 86400) as avg_duration_seconds'
      )
      .order('avg_duration_seconds DESC')
  end

  def scrape_volume_by_course
    @courses = Course.order(:name).pluck(:name, :id)
    @selected_course = params[:course_id] || 'ALL'
    @date_range = params[:date_range] || '7d'
    @start_date = params[:start_date]
    @end_date = params[:end_date]

    @scrape_volume = ScrapeEvent
      .joins(:course)
      .where(has_error: false)
      .where(course_filter)
      .where(date_filter)
      .group('DATE(scrape_start)', 'courses.name')
      .order('DATE(scrape_start) ASC')
      .select(
        'DATE(scrape_start) as scrape_date',
        'courses.name as course_name',
        'COUNT(*) as success_count'
      )
  end

  def course_filter
    return {} if @selected_course == 'ALL'
    { course_id: @selected_course }
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