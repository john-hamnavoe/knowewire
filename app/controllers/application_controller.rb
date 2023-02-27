class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper

  protected

  def ransack_query(model, default_sort = "")
    #binding.remote_pry
    set_filter
    saved_query = Filter.find(session[session_symbol("filter")]) if session[session_symbol("filter")]
    set_last_changed_field(saved_query)
    params[:query] = JSON.load(saved_query&.query) || {}  if params[:query].nil?

    @page = params[:page] || params[:query][:page]
    params[:query][:s] = default_sort if params[:query][:s].nil?

    query = model.column_names.include?("project_id") ? model.where(project_id: current_user.current_project.id) : model
    query = query.where(is_deleted: false) if model.column_names.include?("is_deleted") && params[:query][:is_deleted_true].nil?

    ransack_query = query.ransack(params[:query])
    page = @page || saved_query&.page || 1
    session[session_symbol("filter")] = @filter.id

    update_filter(page)
    return ransack_query, page
  end

  private

  def set_last_changed_field(saved_query)
    return nil if params[:query].nil? || saved_query.nil?
    
    JSON.parse(saved_query.query).each do |k,v|
      next if k == "s" || k == "page" || k == "filter_id"
      if params[:query][k] != v
        @last_changed_field = k
        break
      end
    end
  end

  def set_filter
    @filter = Filter.find(params[:query][:filter_id]) if params[:query] && params[:query][:filter_id]
    @filter = Filter.find(session[session_symbol("filter")]) if session[session_symbol("filter")]
    @filter = Filter.create if @filter.nil?
  end

  def update_filter(page)
    @filter.page = page
    @filter.query = params[:query].to_json if params[:query]
    @filter.sort = params[:query][:s] if params[:query] && params[:query][:s]
    @filter.save
  end
end
