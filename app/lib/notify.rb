class Notify
  class << self
    def error(str, e, args={})
      send_to_rollbar("error", str, e, args)
    end

    def warning(str, e, args={})
      send_to_rollbar("warning", str, e, args)
    end

    private

    def send_to_rollbar(type, str, e, args)
      force = args.delete(:force)
      backtrace = e.respond_to?(:backtrace) && e.backtrace ? e.backtrace.join("\n") : nil
      hash = args.merge(
        error: e,
        backtrace: backtrace,
      )

      if Rails.env.development? && !force
        raise e
      else
        Rollbar.send(type, str, hash)
      end
    end
  end
end
