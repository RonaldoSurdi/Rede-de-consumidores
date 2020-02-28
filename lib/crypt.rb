class Crypt

  def self.crypt(data)
    encryptor = ActiveSupport::MessageEncryptor.new(Consumercard::Application.config.secret_key_base)
    encryptor.encrypt_and_sign data
  end

  def self.decrypt(data)
    encryptor = ActiveSupport::MessageEncryptor.new(Consumercard::Application.config.secret_key_base)
    encryptor.decrypt_and_verify data
  end

end