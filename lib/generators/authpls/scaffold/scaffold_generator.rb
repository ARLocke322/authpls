# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module Authpls
  module Generators
    # Generates a complete authentication implementation
    class ScaffoldGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration
      source_root File.expand_path("../../templates", __dir__)

      def copy_application_controller_concerns
        inject_into_file "app/controllers/application_controller.rb", after: "ActionController::API\n" do
          <<~RUBY
            include ActionController::HttpAuthentication::Token::ControllerMethods
            include Auth::Authentication
            rescue_from ArgumentError, with: :handle_argument_errors
            rescue_from ActiveRecord::RecordNotFound do
              render json: { error: 'Not found' }, status: :not_found
            end
            RATE_LIMIT_RESPONSE = -> { render json: { error: 'Try again later' }, status: :too_many_requests }
          RUBY
        end
      end

      def copy_controllers
        template "users_controller.rb.tt", "app/controllers/auth/users_controller.rb"
        template "sessions_controller.rb.tt", "app/controllers/auth/sessions_controller.rb"
        template "profiles_controller.rb.tt", "app/controllers/auth/profiles_controller.rb"
        template "passwords_controller.rb.tt", "app/controllers/auth/passwords_controller.rb"
        template "registrations_controller.rb.tt", "app/controllers/auth/registrations_controller.rb"
        template "signup_tokens_controller.rb.tt", "app/controllers/auth/signup_tokens_controller.rb"
        template "authentication_concern.rb.tt", "app/controllers/concerns/auth/authentication.rb"
      end

      def copy_migrations
        migration_template "users_migration.rb.tt", "db/migrate/create_users.rb"
        migration_template "sessions_migration.rb.tt", "db/migrate/create_sessions.rb"
        migration_template "signup_tokens_migration.rb.tt", "db/migrate/create_signup_tokens.rb"
      end

      def copy_models
        template "user_model.rb.tt", "app/models/auth/user.rb"
        template "session_model.rb.tt", "app/models/auth/session.rb"
        template "signup_token_model.rb.tt", "app/models/auth/signup_token.rb"
        template "current_model.rb.tt", "app/models/current.rb"
      end

      def copy_jobs
        template "cleanup_expired_sessions_job.rb.tt", "app/jobs/auth/cleanup_expired_sessions_job.rb"
      end

      def copy_mailers
        template "passwords_mailer.rb.tt", "app/mailers/auth/passwords_mailer.rb"
      end

      def copy_serializers
        template "user_serializer.rb.tt", "app/serializers/auth/user_serializer.rb"
        template "session_serializer.rb.tt", "app/serializers/auth/session_serializer.rb"
        template "signup_token_serializer.rb.tt", "app/serializers/auth/signup_token_serializer.rb"
      end

      def copy_routes
        route <<~RUBY
          namespace :auth do
            resource :session, only: %i[create destroy]
            resource :registration, only: %i[create]
            resource :profile, only: %i[show update destroy]
            resources :users, only: %i[index show update destroy]
            resources :passwords, only: %i[create update]
            resources :signup_tokens, only: %i[create]
          end
        RUBY
      end
    end
  end
end
