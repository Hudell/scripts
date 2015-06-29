module OrangeInput
  KEY_CODES = {
    :mouse_left_button => 0x01,
    :mouse_right_button => 0x02,
    :cancel => 0x03,
    :mouse_middle_button => 0x04,
    :any_mouse_button => [0x01, 0x02, 0x04],
    :xbutton1 => 0x05,
    :xbutton2 => 0x06,
    :back => 0x08,
    :tab => 0x09,
    :clear => 0x0c,
    :return => 0x0d,
    :shift => 0x10,
    :control => 0x11,
    :menu => 0x12,
    :pause => 0x13,
    :capital => 0x14,
    :kana => 0x15,
    :junja => 0x17,
    :final => 0x18,
    :hanja => 0x19,
    :escape => 0x1b,
    :convert => 0x1c,
    :non_convert => 0x1d,
    :accept => 0x1e,
    :mode_change => 0x1f,
    :space => 0x20,
    :prior => 0x21,
    :next => 0x22,
    :page_up => 0x21,
    :page_down => 0x22,
    :end => 0x23,
    :home => 0x24,
    :left => 0x25,
    :up => 0x26,
    :right => 0x27,
    :down => 0x28,
    :select => 0x29,
    :print => 0x2a,
    :execute => 0x2b,
    :snapshot => 0x2c,
    :insert => 0x2d,
    :delete => 0x2e,
    :help => 0x2f,
    :n0 => 0x30,
    :key_1 => 0x31,
    :key_2 => 0x32,
    :key_3 => 0x33,
    :key_4 => 0x34,
    :key_5 => 0x35,
    :key_6 => 0x36,
    :key_7 => 0x37,
    :key_8 => 0x38,
    :key_9 => 0x39,
    :colon => 0x3a,
    :semicolon => 0x3b,
    :less => 0x3c,
    :equal => 0x3d,
    :greater => 0x3e,
    :question => 0xef,
    :at => 0x40,
    :a => 0x41,
    :b => 0x42,
    :c => 0x43,
    :d => 0x44,
    :e => 0x45,
    :f => 0x46,
    :g => 0x47,
    :h => 0x48,
    :i => 0x49,
    :j => 0x4a,
    :k => 0x4b,
    :l => 0x4c,
    :m => 0x4d,
    :n => 0x4e,
    :o => 0x4f,
    :p => 0x50,
    :q => 0x51,
    :r => 0x52,
    :s => 0x53,
    :t => 0x54,
    :u => 0x55,
    :v => 0x56,
    :w => 0x57,
    :x => 0x58,
    :y => 0x59,
    :z => 0x5a,
    :left_windows_key => 0x5b,
    :right_windows_key => 0x5c,
    :any_windows_key => [0x5b, 0x5c],
    :apps => 0x5d,
    :asciicircum => 0x5e,
    :sleep => 0x5f,
    :numpad_0 => 0x60,
    :numpad_1 => 0x61,
    :numpad_2 => 0x62,
    :numpad_3 => 0x63,
    :numpad_4 => 0x64,
    :numpad_5 => 0x65,
    :numpad_6 => 0x66,
    :numpad_7 => 0x67,
    :numpad_8 => 0x68,
    :numpad_9 => 0x69,
    :multiply => 0x6a,
    :add => 0x6b,
    :separator => 0x6c,
    :subtract => 0x6d,
    :decimal => 0x6e,
    :divide => 0x6f,
    :f1 => 0x70,
    :f2 => 0x71,
    :f3 => 0x72,
    :f4 => 0x73,
    :f5 => 0x74,
    :f6 => 0x75,
    :f7 => 0x76,
    :f8 => 0x77,
    :f9 => 0x78,
    :f10 => 0x79,
    :f11 => 0x7a,
    :f12 => 0x7b,
    :f13 => 0x7c,
    :f14 => 0x7d,
    :f15 => 0x7e,
    :f16 => 0x7f,
    :f17 => 0x80,
    :f18 => 0x81,
    :f19 => 0x82,
    :f20 => 0x83,
    :f21 => 0x84,
    :f22 => 0x85,
    :f23 => 0x86,
    :f24 => 0x87,
    :numlock => 0x90,
    :scroll => 0x91,
    :left_shift => 0xa0,
    :right_shift => 0xa1,
    :any_shift => [0xa0, 0xa1],
    :left_control => 0xa2,
    :right_control => 0xa3,
    :any_control => [0xa2, 0xa3],
    :left_menu => 0xa4,
    :right_menu => 0xa5,
    :any_menu => [0xa4, 0xa5],
    :browser_back => 0xa6,
    :browser_forward => 0xa7,
    :browser_refresh => 0xa8,
    :browser_stop => 0xa9,
    :browser_search => 0xaa,
    :browser_favorites => 0xab,
    :browser_home => 0xac,
    :volume_mute => 0xad,
    :volume_down => 0xae,
    :volume_up => 0xaf,
    :media_next_track => 0xb0,
    :media_prev_track => 0xb1,
    :media_stop => 0xb2,
    :media_play_pause => 0xb3,
    :launch_mail => 0xb4,
    :launch_media_select => 0xb5,
    :launch_app1 => 0xb6,
    :launch_app2 => 0xb7,
    :cedilla => 0xb8,
    :onesuperior => 0xb9,
    :masculine => 0xba,
    :guillemotright => 0xbb,
    :onequarter => 0xbc,
    :onehalf => 0xbd,
    :threequarters => 0xbe,
    :questiondown => 0xbf,
    :Agrave => 0xc0,
    :Aacute => 0xc1,
    :Acircumflex => 0xc2,
    :Atilde => 0xc3,
    :Adiaeresis => 0xc4,
    :Aring => 0xc5,
    :AE => 0xc6,
    :Ccedilla => 0xc7,
    :Egrave => 0xc8,
    :Eacute => 0xc9,
    :Ecircumflex => 0xca,
    :Ediaeresis => 0xcb,
    :Igrave => 0xcc,
    :Iacute => 0xcd,
    :Icircumflex => 0xce,
    :Idiaeresis => 0xcf,
    :ETH => 0xd0,
    :Ntilde => 0xd1,
    :Ograve => 0xd2,
    :Oacute => 0xd3,
    :Ocircumflex => 0xd4,
    :Otilde => 0xd5,
    :Odiaeresis => 0xd6,
    :multiply => 0xd7,
    :Oslash => 0xd8,
    :Ugrave => 0xd9,
    :Uacute => 0xda,
    :Ucircumflex => 0xdb,
    :Udiaeresis => 0xdc,
    :Yacute => 0xdd,
    :THORN => 0xde,
    :ssharp => 0xdf,
    :agrave => 0xe0,
    :aacute => 0xe1,
    :acircumflex => 0xe2,
    :atilde => 0xe3,
    :adiaeresis => 0xe4,
    :process_key => 0xe5,
    :ae => 0xe6,
    :packet => 0xe7,
    :egrave => 0xe8,
    :eacute => 0xe9,
    :ecircumflex => 0xea,
    :ediaeresis => 0xeb,
    :igrave => 0xec,
    :iacute => 0xed,
    :icircumflex => 0xee,
    :idiaeresis => 0xef,
    :eth => 0xf0,
    :ntilde => 0xf1,
    :ograve => 0xf2,
    :oacute => 0xf3,
    :ocircumflex => 0xf4,
    :otilde => 0xf5,
    :ATTN => 0xf6,
    :CRSEL => 0xf7,
    :EXSEL => 0xf8,
    :EREOF => 0xf9,
    :PLAY => 0xfa,
    :ZOOM => 0xfb,
    :NONAME => 0xfc,
    :PA1 => 0xfd,
    :thorn => 0xfe,
    :ydiaeresis => 0xff
  }

  def self.key_codes
    KEY_CODES
  end

  def self.key_code(key)
    key_codes[key] || 0
  end

  def self.up_button
    [
      key_code(:up)
    ]
  end

  def self.down_button
    [
      key_code(:down)
    ]
  end

  def self.left_button
    [
      key_code(:left)
    ]
  end

  def self.right_button
    [
      key_code(:right)
    ]
  end

  def self.a_button
    [
      key_code(:left_shift),
      key_code(:right_shift)
    ]
  end

  def self.b_button
    [
      key_code(:escape),
      key_code(:x)
    ]
  end

  def self.c_button
    [
      key_code(:return),
      key_code(:space),
      key_code(:z)
    ]
  end

  def self.x_button
    [
      key_code(:a)
    ]
  end

  def self.y_button
    [
      key_code(:s)
    ]
  end

  def self.z_button
    [
      key_code(:d)
    ]
  end

  def self.l_button
    [
      key_code(:page_up),
      key_code(:q)
    ]
  end

  def self.r_button
    [
      key_code(:page_down),
      key_code(:w)
    ]
  end

  SYM_KEYS = {
    :UP => up_button,
    :LEFT => left_button,
    :DOWN => down_button,
    :RIGHT => right_button,
    :A => a_button,
    :B => b_button,
    :C => c_button,
    :X => x_button,
    :Y => y_button,
    :Z => z_button,
    :L => l_button,
    :R => r_button,
    # :F5 => F5,
    # :F6 => F6,
    # :F7 => F7,
    # :F8 => F8,
    # :F9 => F9,
    # :SHIFT => SHIFT,
    # :CTRL => CTRL,
    # :ALT => ALT
  }


  GetKeyboardState = Win32API.new("user32.dll", "GetKeyboardState", "I", "I")
  MapVirtualKeyEx = Win32API.new("user32.dll", "MapVirtualKeyEx", "IIL", "I")
  ToUnicodeEx = Win32API.new("user32.dll", "ToUnicodeEx", "LLPPILL", "L")
  GetPrivateProfileString = Win32API.new('kernel32', 'GetPrivateProfileString'  , 'ppppip', 'i')
  WritePrivateProfileString = Win32API.new('kernel32', 'WritePrivateProfileString', 'pppp', 'i')
  @language_layout = Win32API.new("user32.dll", "GetKeyboardLayout", "L", "L").call(0)
  DOWN_STATE_MASK = (0x8 << 0x04)
  DEAD_KEY_MASK = (0x8 << 0x1C)
  UNICODE_TO_UTF8 = Encoding::Converter.new(Encoding.list[2], Encoding.list[1])

  @state = DL::CPtr.new(DL.malloc(256), 256)
  @triggered = Array.new(256, false)
  @pressed = Array.new(256, false)
  @released = Array.new(256, false)
  @repeated = Array.new(256, 0)
  @pressed_any = false
  @triggered_any = false
  @last_pressed_key = nil
  @last_triggered_key = nil

  class << self
    attr_reader :triggered, :pressed, :released, :repeated, :state
  end

  def self.set_key_values(key, serialized_values)
    values = deserialize_key_array(serialized_values)
    key.clear
    values.each do |new_key|
      key << new_key
    end
  end

  def self.shifted?
    return true if press?(key_code(:shift))
    return true if caps_on?
    return false
  end

  def self.caps_on?
    return true if GetKeyboardState.call(key_code(:capital)) == 1
    return false 
  end

  def self.load_keys_from_file
    buffer = [].pack('x256')
    section = 'KeyboardScheme'
    filename = './Game.ini'
    get_option = Proc.new do |key, default_value|
      l = GetPrivateProfileString.call(section, key, default_value, buffer, buffer.size, filename)
      buffer[0, l]
    end

    a = get_option.call('key_a', 'empty')
    if a != 'empty'
      set_key_values(A, a)
    end
    
    b = get_option.call('key_b', 'empty')
    if b != 'empty'
      set_key_values(B, b)
    end

    c = get_option.call('key_c', 'empty')
    if c != 'empty'
      set_key_values(C, c)
    end

    x = get_option.call('key_x', 'empty')
    if x != 'empty'
      set_key_values(X, x)
    end

    y = get_option.call('key_y', 'empty')
    if y != 'empty'
      set_key_values(Y, y)
    end

    z = get_option.call('key_z', 'empty')
    if z != 'empty'
      set_key_values(Z, z)
    end

    r = get_option.call('key_r', 'empty')
    if r != 'empty'
      set_key_values(R, r)
    end

    l = get_option.call('key_l', 'empty')
    if l != 'empty'
      set_key_values(L, l)
    end
  end

  def self.serialize_key_array(key_array)
    new_array = []
    key_array.each do |key|
      new_array << key
    end

    return JSON::encode_array(new_array)
  end

  def self.deserialize_key_array(serialized_string)
    key_array = []
    serialized_array = JSON::decode(serialized_string)

    if serialized_array
      serialized_array.each do |key_num|
        key_array << key_num.to_i
      end
    end

    return key_array
  end

  def self.save_keys_to_file
    section = 'KeyboardScheme'
    filename = './Game.ini'
    set_option = Proc.new do |key, value|
      WritePrivateProfileString.call(section, key, value.to_s, filename)
    end

    set_option.call('key_a', serialize_key_array(A))
    set_option.call('key_b', serialize_key_array(B))
    set_option.call('key_c', serialize_key_array(C))
    set_option.call('key_x', serialize_key_array(X))
    set_option.call('key_y', serialize_key_array(Y))
    set_option.call('key_z', serialize_key_array(Z))
    set_option.call('key_r', serialize_key_array(R))
    set_option.call('key_l', serialize_key_array(L))
  end

  def self.update
    GetKeyboardState.call(@state.to_i)

    @pressed_any = false
    @last_pressed_key = nil
    @triggered_any = false
    @last_triggered_key = nil

    0.upto(255) do |key|
      if @state[key] & DOWN_STATE_MASK == DOWN_STATE_MASK
        @released[key] = false
        @pressed[key]  = true if (@triggered[key] = !@pressed[key])
        @repeated[key] < 17 ? @repeated[key] += 1 : @repeated[key] = 15
        
        if @pressed[key]
          @pressed_any = true
          @last_pressed_key = key
        end

        if @triggered[key]
          @triggered_any = true
          @last_triggered_key = key
        end
        
      elsif !@released[key] and @pressed[key]
        @triggered[key] = false
        @pressed[key]   = false
        @repeated[key]  = 0
        @released[key]  = true
      else
        @released[key]  = false
      end
    end
  end

  def self.pressed_any
    @pressed_any
  end
  
  def self.last_pressed_key
    @last_pressed_key
  end

  def self.triggered_any
    @triggered_any
  end
  
  def self.last_triggered_key
    @last_triggered_key
  end

  def self.press?(keys)
    if keys.is_a?(Numeric)
      k = keys.to_i
      return (@pressed[k] and !@triggered[k])
    elsif keys.is_a?(Array)
      return keys.any? {|key| self.press?(key) }
    elsif keys.is_a?(Symbol)
      if SYM_KEYS.key?(keys)
        return SYM_KEYS[keys].any? {|key| (@pressed[key]  and !@triggered[key]) }
      elsif (key_codes.key?(keys))
        k = key_codes[keys]
        return (@pressed[k] and !@triggered[k])
      else
        return false
      end
    end
  end

  def self.trigger?(keys)
    if keys.is_a?(Numeric)
      return @triggered[keys.to_i]
    elsif keys.is_a?(Array)
      return keys.any? {|key| @triggered[key]}
    elsif keys.is_a?(Symbol)
      if SYM_KEYS.key?(keys)
        return SYM_KEYS[keys].any? {|key| @triggered[key]}
      elsif key_codes.key?(keys)
        return @triggered[key_codes[keys]]
      else
        return false
      end
    end
  end

  def self.repeat?(keys)
    if keys.is_a?(Numeric)
      key = keys.to_i
      return @repeated[key] == 1 || @repeated[key] == 16
    elsif keys.is_a?(Array)
      return keys.any? {|key| @repeated[key] == 1 || @repeated[key] == 16}
    elsif keys.is_a?(Symbol)
      if SYM_KEYS.key?(keys)
        return SYM_KEYS[keys].any? {|key| @repeated[key] == 1 || @repeated[key] == 16}
      elsif key_codes.key?(keys)
        return @repeated[key_codes[keys]] == 1 || @repeated[key_codes[keys]] == 16
      else
        return false
      end
    end
  end

  def self.release?(keys)
    if keys.is_a?(Numeric)
      return @released[keys.to_i]
    elsif keys.is_a?(Array)
      return keys.any? {|key| @released[key]}
    elsif keys.is_a?(Symbol)
      if SYM_KEYS.key?(keys)
        return SYM_KEYS[keys].any? {|key| @released[key]}
      elsif key_codes.key?(keys)
        return @released[key_codes[keys]]
      else
        return false
      end
    end
  end

  def self.get_character(vk)
    c = MapVirtualKeyEx.call(vk, 2, @language_layout)
    return "" if c < 32 && (c & DEAD_KEY_MASK != DEAD_KEY_MASK)
    result = "\0" * 2
    length = ToUnicodeEx.call(vk, MapVirtualKeyEx.call(vk, 0, @language_layout), @state, result, 2, 0, @language_layout)
    return (length == 0 ? "" : result)
  end

  AccentsCharsConv = {
    "A" =>  ["À", "Á", "Â", "Ã", "Ä"],
    "E" =>  ["È", "É", "Ê",  0,  "Ë"],
    "I" =>  ["Ì", "Í", "Î",  0,  "Ï"],
    "O" =>  ["Ò", "Ó", "Ô", "Õ", "Ö"],
    "U" =>  ["Ù", "Ú", "Û",  0,  "Ü"],
    "C" =>  [ 0 , "Ç",  0 ,  0,  0 ],
    "N" =>  [ 0 ,  0,  0 , "Ñ",  0 ],
    "Y" =>  [ 0 , "Ý",  0 ,  0,  0],
    "a" =>  ["à", "á", "â", "ã", "ä"],
    "e" =>  ["è", "é", "ê",  0 , "ë"],
    "i" =>  ["ì", "í", "î",  0 , "ï"],
    "o" =>  ["ò", "ó", "ô", "õ", "ö"],
    "u" =>  ["ù", "ú", "û",  0 , "ü"],
    "c" =>  [ 0 , "ç",  0 ,  0 ,  0 ],
    "n" =>  [ 0 ,  0 ,  0 , "ñ",  0 ],
    "y" =>  [ 0 , "ý",  0 ,  0 , 0],
  }

  # Letters that can have accent
  PssbLetters   = "AEIOUCNYaeioucny"
  # Accents, in ASCII, configured at runtime to avoid encoding troubles
  Accents = [96.chr, 180.chr, 94.chr, 126.chr, 168.chr].join
  NonCompatChars = [180, 168]
  @last_accent = nil
  @previous_accent = nil

  def self.previous_accent
    @previous_accent
  end
  def self.previous_accent=(value)
    @previous_accent = nil
  end

  def self.get_input_string
    result = ""
    31.upto(255) {|key|
            if self.repeat?(key)
              c = self.get_character(key)
              if (cc = c.unpack("C")[0]) and NonCompatChars.include?(cc)
                    result += cc.chr
              else
                    result += UNICODE_TO_UTF8.convert(c) if c != ""
              end
            end
    }
    return "" if result == ""

    if @last_accent
      result = @last_accent + result
      @last_accent = nil
    end

    f_result = ""
    jump    = false
    for i in 0 ... result.length
      c = result[i]
      if jump
        jump = false
        next
      end

      begin
        if Accents.include?c
          if (nc = result[i+1]) != nil
            if PssbLetters.include?(nc)
              if (ac = AccentsCharsConv[nc][Accents.index(c)]) != 0
                f_result << ac
                jump = true
              else
                f_result << c
                f_result << nc
                jump = true
              end
            elsif Accents.include?(nc)
              f_result << c
              f_result << nc
              jump = true
            else
              f_result << c
              f_result << nc
              jump = true
            end
          else
            @last_accent = c
          end
        else
          f_result << c
        end
      rescue
        f_result << c
      end
    end
    return f_result
  end
end

module Input
  class << self
    alias :hudell_update :update
  end

  def self.update
    OrangeInput.update
    hudell_update
  end

  def self.triggered_any
    triggered_any?
  end

  def self.triggered_any?
    return true if trigger?(:A)
    return true if trigger?(:B)
    return true if trigger?(:C)
    return true if trigger?(:X)
    return true if trigger?(:Y)
    return true if trigger?(:Z)
    return true if trigger?(:UP)
    return true if trigger?(:DOWN)
    return true if trigger?(:LEFT)
    return true if trigger?(:RIGHT)
    return false
  end  
end
