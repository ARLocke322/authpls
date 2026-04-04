# frozen_string_literal: true

require "my_auth/railtie" if defined?(Rails)
require_relative "authpls/version"

module Authpls
  class Error < StandardError; end
  # Your code goes here...
end
