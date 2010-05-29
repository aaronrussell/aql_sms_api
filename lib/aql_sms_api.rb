require 'httparty'

module AQL
  
  class SMS
    
    include HTTParty
    base_uri "https://gw.aql.com/sms/"
    
    def self.authenticate(opts)
      default_params opts
    end
        
    def self.check_credit
      res = get "/postmsg.php", :query => {:cmd => "credit"}
      valid?(res) ? (res == "AQSMS-AUTHERROR" ? false : res.match(/\=(\d+)/)[1]).to_i : res
    end
    
    def self.send_message(dests = [], msg = "", opts = {})
      numbers = dests.collect{|n| format_number(n)}.join(",")
      res = get "/sms_gw.php", :query => opts.merge(:destination => numbers, :message => msg)
      valid?(res) ? SMSResponse.new(res) : res
    end
    
    def self.format_number(number, format = :uk)
      NumberFormat.send(format, number)
    end
    
    private
    
    def self.valid?(res)
      res.code == 200
    end
    
  end
  
  class SMSResponse
    
    attr_reader :code, :credits, :message
    
    def initialize(res)
      parts = res.match(/^([0-9]):(\d+)\s(.+)$/)
      @code = parts[1]
      @credits = parts[2]
      @message = parts[3].strip
    end
    
  end
  
  class SMSDeliveryReport
    
    attr_reader :code, :message, :destination
    
    def initialize(params)
      @code         = params[:reportcode].to_s
      @destination  = params[:destinationnumber].to_s
      @message      = case @code
        when "1" then "Delivered to Handset"
        when "2" then "Rejected from Handset"
        when "4" then "Buffered in transit (phone probably off / out of reception)"
        when "8" then "Accepted by SMSC"
        when "16" then "Rejected by SMSC"
        else "Unknown response code"
      end
    end
    
  end
  
  module NumberFormat
    
    def self.uk(number)
      number.
        gsub(/\D/, "").               # removes all non digit characters
        gsub(/^00([1-9]{2})/, "\\1"). # asumes numbers beginning 00 are int and strips leading 00
        gsub(/^0([1-9])/, "44\\1")    # removes leading 0 and add international code
    end
    
  end
  
end