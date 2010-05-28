require 'httparty'

module AQL
  
  class SMS
    
    include HTTParty
    base_uri "https://gw.aql.com/sms/"
    debug_output $stderr
    
    def self.authenticate(user = nil, pass = nil, orig = nil)
      @auth = {:username => user, :password => pass, :originator => orig}
    end
    
    authenticate
        
    def self.check_credit
      res = get "/postmsg.php", :query => @auth.merge(:cmd => "credit")
      valid?(res) ? (res == "AQSMS-AUTHERROR" ? false : res.match(/\=(\d+)/)[1]).to_i : res
    end
    
    def self.send_message(dests = [], msg = "", opts = {})
      numbers = dests.collect{|n| format_number(n)}.join(",")
      res = get "/sms_gw.php", :query => @auth.merge(:destination => numbers, :message => msg).merge(opts)
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
  
  module NumberFormat
    
    def self.uk(number)
      number.
        gsub(/\D/, "").               # removes all non digit characters
        gsub(/^00([1-9]{2})/, "\\1"). # asumes numbers beginning 00 are int and strips leading 00
        gsub(/^0([1-9])/, "44\\1")    # removes leading 0 and add international code
    end
    
  end
  
end