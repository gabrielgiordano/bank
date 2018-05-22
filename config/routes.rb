# frozen_string_literal: true

Rails.application.routes.draw do
  get '/accounts/:id', to: 'accounts#show'
  post '/transfers', to: 'transfers#create'
end
