module JeraPush
  class JeraPushController < ::ApplicationController
    protected

    def render_invalid_params
      render nothing: true, status: :unprocessable_entity
    end

    def render_not_found
      render nothing: true, status: :not_found
    end

    def render_object(object)
      if object.nil? || object.errors.any?
        render_unprocessable_entity(object)
      else
        render_object_success(object)
      end
    end

    private

    def render_object_success(object)
      render json: { data: object, status: :success }, status: :ok
    end

    def render_unprocessable_entity(object)
      render json: {
          data: object,
          errors: object.errors.full_messages,
          status: :unprocessable_entity
        }, status: :ok
    end
  end
end
