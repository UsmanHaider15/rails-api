class ApplicationController < ActionController::API
    include JsonapiErrorsHandler
    ErrorMapper.map_errors!({
        'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound'
    })
    rescue_from ::StandardError, with: lambda { |e| handle_error(e) }
    rescue_from UserAuthenticator::AuthenticationError, with: :authenticator_error
  
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
    
end
