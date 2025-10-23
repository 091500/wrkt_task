class FindRecipient
  include Interactor

  def call
    recipient = User.find_by(id: context.recipient_id)

    if recipient
      context.recipient = recipient
    else
      context.fail!(error: "Recipient not found", error_code: 404)
    end
  end
end
