class ServiceKitsAttrReader
  def get_main_fields kit
    main = {:sku => kit.kitSku,
            :partNumber => kit.kitPartNumber,
            :description => kit.description,
            :tiSku=> kit.tiKitSku,
            :tiPartNumber => kit.tiKitPartNumber
    }
  end

  def convert_hash_to_array hash
    array = []
    hash.each do |key,value|
      array.push value
    end
    array
  end
  def get_attribute id
    hash = {}
    sks = VmagmiServiceKit.where(sku: id)
    sks.each do |sk|
      unless  hash.has_key? sk.kitSku.to_s
        hash[sk.kitSku.to_s] = get_main_fields(sk)
      end
    end
    convert_hash_to_array hash
  end
end