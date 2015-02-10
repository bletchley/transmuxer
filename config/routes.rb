Rails.application.routes.draw do
  namespace :transmuxer do
    post "/notifications/:resource/:id" => "notifications#create", as: "notifications"
  end
end