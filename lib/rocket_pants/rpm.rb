require "rocket_pants/rpm/version"
require "newrelic_rpm"
require 'new_relic/agent/instrumentation/action_controller_subscriber'

module RocketPants
  module RPM

    DependencyDetection.defer do
      @name = :rails4_rocketpants_controller

      depends_on do
        defined?(::Rails) && ::Rails::VERSION::MAJOR.to_i == 4
      end

      depends_on do
        defined?(RocketPants) && defined?(RocketPants::Base)
      end

      executes do
        ::NewRelic::Agent.logger.info 'Installing Rails 4 RocketPants Controller instrumentation'
      end

      executes do
        class RocketPants::Base
          include NewRelic::Agent::Instrumentation::ControllerInstrumentation
        end
        NewRelic::Agent::Instrumentation::ActionControllerSubscriber \
          .subscribe(/^process_action.rocket_pants$/)
      end
    end

  end
end
