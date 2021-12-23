class ApplicationController < ActionController::API
    class AuthorizationError < StandardError; end
    include JsonapiErrorsHandler
    ErrorMapper.map_errors!({
        'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound'
    })

    before_action :authorize!
    
    rescue_from ::StandardError, with: lambda { |e| handle_error(e) }
    rescue_from UserAuthenticator::AuthenticationError, with: :authenticator_error
    rescue_from AuthorizationError, with: :authorization_error
  
    private

    def authorize!
        raise AuthorizationError unless current_user
    end

    def access_token 
        provided_token = request.authorization&.gsub(/\ABearer\s/, '')
        access_token = AccessToken.find_by(token: provided_token)
    end

    def current_user
        current_user = access_token&.user
    end
    
    def authenticator_error
        error =  {
            "status": "401",
            "source": { "pointer": "/code" },
            "title":  "Invalid Code Attribute",
            "detail": "You provided invalid code attribute."
        }          
    
        render json: { "errors": [error] }, status: 401
    end

    def authorization_error
        error =  {
            "status": "403",
            "source": { "pointer": "/header/authorization" },
            "title":  "Invalid header authorization",
            "detail": "You provided invalid header authorization."
        }          
    
        render json: { "errors": [error] }, status: 401
    end

end
