class  OverviewsController < ApplicationController

  def analytics
    success_rate_over_time
    error_type_distribution

    respond_to do |format|
      format.html
    end
  end

  private


  def success_rate_over_time
    @success_rates = ScrapeEvent
                    .group(Arel.sql("DATE(created_at)"))
                    .order(Arel.sql("DATE(created_at)"))
                    .pluck(
                      Arel.sql("DATE(created_at) as date"),
                      Arel.sql("COUNT(CASE WHEN has_error = false THEN 1 END)"),
                      Arel.sql("COUNT(*)"),
                      Arel.sql("ROUND(COUNT(CASE WHEN has_error = false THEN 1 END) * 100.0 / COUNT(*), 1)")
                    )
    @chart_data = @success_rates.each_with_object({}) do |(date, successes, total, rate), hash|
      hash[date] = rate
    end
  end

  def error_type_distribution
    @error_distribution = ScrapeError
      .group(:error_type)
      .order('count_all DESC')
      .count
  end
end