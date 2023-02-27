class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper

  protected

  def ransack_query(model, default_sort = "")
    #binding.remote_pry
    page = current_page

    params[:query] = {} if params[:query].nil?

    apply_sort_to_ransack_params(default_sort)

    apply_query_to_ransack_params

    query = model.column_names.include?("project_id") ? model.where(project_id: current_user.current_project.id) : model
    query = query.where(is_deleted: false) if model.column_names.include?("is_deleted") && params[:query][:is_deleted_true].nil?

    ransack_query = query.ransack(params[:query])

    return ransack_query, page
  end

  private

  def apply_sort_to_ransack_params(default_sort)
    # update kredis hash with current sort if user has changed sort then return sort from kredis hash or default to default_sort
    sort_key = search_hash_key("sort")
    current_user.index_settings.update(sort_key =>  params[:query][:s]) if params[:query][:s].present?
    params[:query][:s] = current_user.index_settings[sort_key]|| default_sort
  end

  def apply_query_to_ransack_params
    # update kredis hash with current query if user has changed query then return query from kredis hash and apply any default filters
    params[:query].each do |key, value|
      next if key == "s" || key.ends_with?("_true") || key.ends_with?("_false")
      query_key = search_hash_key(key)
      old_value = current_user.index_searches[query_key]
      if value.present?
        @last_changed_field = key unless old_value == value
      end
      current_user.index_searches.update(query_key =>  value)
      Rails.logger.info "[Application][Controller][Cache]: query_key: #{query_key}, value: #{value}, old_value: #{old_value}, last_changed_field: #{@last_changed_field}"
    end

    current_user.index_searches.keys.each do |key|
      query_key = search_query_key_from_hash_key(key)
      Rails.logger.info "[Application][Controller][Fetch]: key: #{key}, query_key: #{query_key}"
      next if query_key.nil?
      params[:query][query_key] = current_user.index_searches[key] if params[:query][query_key].nil?
    end
  end

  def current_page
    # update kredis hash with current page if user has changed page then return current page from kredis hash or default to 1
    page_key = search_hash_key("page")
    current_user.index_settings.update(page_key =>  params[:page]) if params[:page].present?
    current_user.index_settings[page_key] || 1
  end

  def search_hash_key(name, path = nil)
    full_path = path&.split("?") || request.fullpath.split("?")
    session_path = full_path.first.split("/")
    "#{session_path.second_to_last}_#{session_path.last}_#{name}"
  end

  def search_query_key_from_hash_key(hash_key)
    base_key = search_hash_key("")
    return nil unless hash_key.start_with?(base_key)

    hash_key.split(base_key).last
  end
end
