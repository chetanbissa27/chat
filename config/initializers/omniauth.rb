Rails.application.config.middleware.use OmniAuth::Builder do

  if (Rails.env == 'production')
    provider :facebook, "890256614356629",'2c9c2419dbb289260c72ddeee03a9bfe', {:scope => 'user_about_me,  user_birthday, user_relationships, user_education_history, email, user_location'}
  else
    provider :facebook, "862644933814321",'c1fc6e3d02465446cde0135cd8d0811e'
  end
end