json.contacts do |contacts|
  contacts.array! @contacts do |contact|
    json.partial! 'api/contacts/contact', contact: contact
  end
end