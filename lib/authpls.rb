# frozen_string_literal: true

require "authpls/railtie" if defined?(Rails)
require_relative "authpls/version"

module Authpls
  class Error < StandardError; end
  # Your code goes here...
end
