class ApplicationController < ActionController::API
    class AuthorizationError < StandardError; end
    include JsonapiErrorsHandler
    ErrorMapper.map_errors!({
        'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound'
    })
    rescue_from ::StandardError, with: lambda { |e| handle_error(e) }
    rescue_from UserAuthenticator::AuthenticationError, with: :authenticator_error
    rescue_from AuthorizationError, with: :authorization_error
  
    private
    
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
