Dir[File.join(__dir__, "/patme/arguments/*")].each{|path| require path}
Dir[File.join(__dir__, "/patme/*.rb")].each{|path| require path}

module Patme

end
