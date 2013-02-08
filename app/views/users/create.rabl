object @user

attributes :fb_id

puts "Accesstoken "+@access_token

node :access_token do |token|
	token.getAccessToken
end