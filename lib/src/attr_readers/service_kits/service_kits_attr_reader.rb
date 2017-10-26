class ServiceKitsAttrReader

  def get_main_fields kit
    {
        :sku => kit.kitSku,
        :partNumber => kit.kitPartNumber,
        :description => kit.description,
        :tiSku => kit.tiKitSku,
        :tiPartNumber => kit.tiKitPartNumber
    }
  end

    def get_attribute id
    hash = {}
    sks = VmagmiServiceKit.where(sku: id).all
    sks.each do |sk|
      unless hash.has_key? sk.kitSku.to_s
        hash[sk.kitSku.to_s] = get_main_fields(sk)
      end
    end
    hash.values
  end
end