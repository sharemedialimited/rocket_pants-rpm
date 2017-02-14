require "rocket_pants/rpm/version"
require "newrelic_rpm"
require 'new_relic/agent/instrumentation/rails5/action_controller'

module RocketPants
  module RPM

    DependencyDetection.defer do
      @name = :rails5_rocketpants_controller

      depends_on do
        defined?(::Rails) && ::Rails::VERSION::MAJOR.to_i == 5
      end

      depends_on do
        defined?(RocketPants) && defined?(RocketPants::Base)
      end

      executes do
        ::NewRelic::Agent.logger.info 'Installing Rails 5 RocketPants Controller instrumentation'
      end

      executes do
        class RocketPants::Base
          include NewRelic::Agent::Instrumentation::ControllerInstrumentation
        end
        ActiveSupport::Notifications.subscribe(/^process_action.rocket_pants$/,
          NewRelic::Agent::Instrumentation::ActionControllerSubscriber.new)
      end
    end

  end
end
