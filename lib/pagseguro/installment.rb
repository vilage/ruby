module PagSeguro
  class Installment
    include Extensions::MassAssignment

    # Set the credit card brand.
    attr_accessor :credit_card_brand

    # Set the installments quantity.
    attr_accessor :quantity

    # Set the amount.
    attr_accessor :amount

    # Set total amount.
    attr_accessor :total_amount

    # Set interest free.
    attr_accessor :interest_free

    # Find installment options by a given amount
    def self.find(amount, credit_card_brand = nil)
      string = "installments?amount=#{amount}"
      string += "&creditCardBrand=#{credit_card_brand}" if credit_card_brand
      load_from_response Request.get(string)
    end

    # Serialize the HTTP response into data.
    def self.load_from_response(response) # :nodoc:
      if response.success? and response.xml?
        Nokogiri::XML(response.body).css("installments").map do |node|
          load_from_xml(node)
        end
      else
        Response.new Errors.new(response)
      end
    end

    # Serialize the XML object.
    def self.load_from_xml(xml) # :nodoc:
      new Serializer.new(xml).serialize
    end
  end
end