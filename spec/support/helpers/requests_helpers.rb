module RequestsHelpers
  def login(uid)
    request_params = {
      'email' => uid,
      'password' => '12345678'
    }
    post "/auth/sign_in", params: request_params 
    return set_request_headers(response.headers)
  end

  def set_request_headers(resp)
    { 
      'access-token' => resp['access-token'],
      'client' => resp['client'],
      'uid' => resp['uid']
    }
  end
end