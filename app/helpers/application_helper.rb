module ApplicationHelper
  def jsonapi_response(resource, serializer)
    render json: serializer.new(resource).serializable_hash
  end

  def error_response(context, response_status = :unprocessable_entity)
    error_detail = context[:error] || "An error occurred"
    response_status = context[:error_code] || response_status

    render json: { error: error_detail }, status: response_status
  end
end
