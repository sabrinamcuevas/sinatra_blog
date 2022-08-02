class SscoolErrorHandler
  ERRORS = {
    '0' => 'valid user',
    '1' => 'banned user',
    '2' => 'user without documentation.',
    '3' => 'There was an error please try again later',
    '4' => 'Error! the information could not be saved',
    '5' => 'Error! the information could not be updated',
    '6' => 'Error! the information could not be deleted',
    '7' => 'Error! This section has an associated article',
    '8' => 'Error! This chapter has an associated article'
  }.freeze

  def self.get_error(code)
    ERRORS[code.to_s]
  end
end
