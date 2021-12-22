class AccessTokensController < ApplicationController
    def create 
        authenticator = UserAuthenticator.new(params[:code])
        authenticator.perform

        render json: AccessTokenSerializer.new(authenticator.access_token), status: 201
    end

    def destroy
        raise AuthorizationError
    end

end
