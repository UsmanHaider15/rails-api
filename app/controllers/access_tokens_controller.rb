class AccessTokensController < ApplicationController
    skip_before_action :authorize!, only: :create
    def create 
        authenticator = UserAuthenticator.new(params[:code])
        authenticator.perform

        render json: AccessTokenSerializer.new(authenticator.access_token), status: 201
    end

    def destroy
        current_user.access_token.destroy
    end

end
