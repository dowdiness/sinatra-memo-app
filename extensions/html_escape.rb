# frozen_string_literal: true

require 'erb'
require 'sinatra/base'

module Sinatra
  module HTMLEscapeHelper
    def h(text)
      ERB::Util.html_escape(text)
    end
  end

  helpers HTMLEscapeHelper
end
