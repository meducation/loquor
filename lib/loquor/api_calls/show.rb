module Loquor
  class ApiCall::Show < ApiCall

    def initialize(klass, id)
      super(klass)
      @id = id
    end

    def execute
      begin
        get_data
      rescue RestClient::ResourceNotFound
        if Loquor.config.retry_404s
          sleep(1)
          get_data
        else
          raise
        end
      end
    end

    private
    def get_data
      options = {cache: klass.cache}
      klass.new Loquor.get("#{klass.path}/#{@id}", options)
    end
  end
end
