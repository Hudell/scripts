$imported ||= {}
$imported[:HudellBazaar] = 1.0

module HudellBazaar
  BAZAAR_MATERIALS_VARIABLE_INDEX = 1
  BAZAAR_CRAFTS_VARIABLE_INDEX = 2

  #Once an item can be crafted, it will never disappear from the list again if this setting is set to FALSE
  #If it is set to TRUE, only items you can craft at the moment will be visible
  HIDE_WHEN_DISABLED = false

  #types
  ITEM = 0
  WEAPON = 1
  ARMOR = 2  

  def self.get_sold_amount(item_id)
    return 0 if $game_variables[BAZAAR_MATERIALS_VARIABLE_INDEX].nil?
    return 0 unless $game_variables[BAZAAR_MATERIALS_VARIABLE_INDEX].is_a? Hash
    return 0 if $game_variables[BAZAAR_MATERIALS_VARIABLE_INDEX][item_id].nil?
    return $game_variables[BAZAAR_MATERIALS_VARIABLE_INDEX][item_id]
  end

  def self.item_is_material?(item_id)
    organize_materials if @material_list.nil?

    return false if @material_list.nil?

    return @material_list.include? item_id
  end

  def self.change_sold_amount(item_id, amount_sold_now)
    $game_variables[BAZAAR_MATERIALS_VARIABLE_INDEX] = {} if $game_variables[BAZAAR_MATERIALS_VARIABLE_INDEX].nil?
    $game_variables[BAZAAR_MATERIALS_VARIABLE_INDEX] = {} unless $game_variables[BAZAAR_MATERIALS_VARIABLE_INDEX].is_a? Hash

    if $game_variables[BAZAAR_MATERIALS_VARIABLE_INDEX][item_id].nil?
      $game_variables[BAZAAR_MATERIALS_VARIABLE_INDEX][item_id] = amount_sold_now
    else
      $game_variables[BAZAAR_MATERIALS_VARIABLE_INDEX][item_id] = $game_variables[BAZAAR_MATERIALS_VARIABLE_INDEX][item_id] + amount_sold_now
    end

    $game_variables[BAZAAR_MATERIALS_VARIABLE_INDEX][item_id] = 0 if $game_variables[BAZAAR_MATERIALS_VARIABLE_INDEX][item_id] < 0
  end

  def self.get_item_type(item)
    if item.is_a?(RPG::Weapon)
      return WEAPON
    elsif item.is_a?(RPG::Armor)
      return ARMOR
    else
      return ITEM
    end
  end

  def self.register_craft(item, number)
    $game_variables[BAZAAR_CRAFTS_VARIABLE_INDEX] = {} if $game_variables[BAZAAR_CRAFTS_VARIABLE_INDEX].nil?
    $game_variables[BAZAAR_CRAFTS_VARIABLE_INDEX] = {} unless $game_variables[BAZAAR_CRAFTS_VARIABLE_INDEX].is_a? Hash

    item_type = get_item_type(item)
    item_id = item.id

    $game_variables[BAZAAR_CRAFTS_VARIABLE_INDEX][item_type] = {} if $game_variables[BAZAAR_CRAFTS_VARIABLE_INDEX][item_type].nil?
    $game_variables[BAZAAR_CRAFTS_VARIABLE_INDEX][item_type][item_id] = 0 if $game_variables[BAZAAR_CRAFTS_VARIABLE_INDEX][item_type][item_id].nil?

    $game_variables[BAZAAR_CRAFTS_VARIABLE_INDEX][item_type][item_id] = $game_variables[BAZAAR_CRAFTS_VARIABLE_INDEX][item_type][item_id] + number

    organize_recipes if @item_recipes.nil?
    case item_type
      when WEAPON
        recipe = @weapon_recipes[item.id]
      when ARMOR
        recipe = @armor_recipes[item.id]
      else
        recipe = @item_recipes[item.id]
    end

    recipe[:materials].keys.each do |mat_id|
      amount = recipe[:materials][mat_id]

      change_sold_amount(mat_id, number * amount * -1)
    end
  end

  def self.get_real_crafts_registered(item)
    return false if $game_variables[BAZAAR_CRAFTS_VARIABLE_INDEX].nil?
    return false unless $game_variables[BAZAAR_CRAFTS_VARIABLE_INDEX].is_a? Hash
    item_type = get_item_type(item)
    item_id = item.id
    return false if $game_variables[BAZAAR_CRAFTS_VARIABLE_INDEX][item_type].nil?
    return false if $game_variables[BAZAAR_CRAFTS_VARIABLE_INDEX][item_type][item_id].nil?
    return $game_variables[BAZAAR_CRAFTS_VARIABLE_INDEX][item_type][item_id]
  end

  def self.get_crafts_registered(item)
    crafts = get_real_crafts_registered(item)

    return 0 if crafts == false
    return crafts
  end

  def self.get_recipe_item(recipe)
    return nil if recipe.nil?

    case recipe[:type]
      when WEAPON
        item = $data_weapons[recipe[:id]]
      when ARMOR
        item = $data_armors[recipe[:id]]
      else
        item = $data_items[recipe[:id]]
    end

    return item
  end

  def self.get_crafts
    list = []

    if $imported[:HudellBazaar_Recipes].nil?
      raise 'Missing Bazaar Recipes'
    end

    RECIPES.each do |recipe|
      item = get_recipe_item(recipe)

      add = false
      if get_real_crafts_registered(item) != false
        add = true unless HIDE_WHEN_DISABLED
      else
        add = get_max_crafts(item) > 0
      end

      if add
        #Register it with number 0 just so that the system can remember this craft was once available
        register_craft(item, 0)

        list << [recipe[:type], recipe[:id], 0, 0]
      end 
    end

    return list
  end

  #Organizes the materials list in a way that is faster to work with
  def self.organize_materials
    @material_list = [] if @material_list.nil?
    
    RECIPES.each do |recipe|
      unless recipe[:materials].nil?
        recipe[:materials].keys.each do |mat_id|
          @material_list << mat_id unless @material_list.include? mat_id
        end
      end
    end
  end

  #organizes the recipe list in a way that is faster to work with
  def self.organize_recipes
    @item_recipes = {}
    @weapon_recipes = {}
    @armor_recipes = {}

    RECIPES.each do |recipe|
        case recipe[:type]
            when ITEM
                @item_recipes[recipe[:id]] = recipe
            when WEAPON
                @weapon_recipes[recipe[:id]] = recipe
            when ARMOR
                @armor_recipes[recipe[:id]] = recipe
        end
    end
  end  

  def self.get_max_crafts_recipe(recipe)
    item = get_recipe_item(recipe)
    return get_max_crafts(item)
  end

  def self.get_max_crafts(item)
    return 0 if item.nil?
    organize_recipes if @item_recipes.nil?

    if item.is_a?(RPG::Weapon)
      recipes = @weapon_recipes
    elsif item.is_a?(RPG::Armor)
      recipes = @armor_recipes
    else
      recipes = @item_recipes
    end

    recipe = recipes[item.id]
    return 0 if recipe.nil?

    unless recipe[:prev_recipe].nil?
      case recipe[:prev_recipe][:type]
        when WEAPON
          craft = $data_weapons[recipe[:prev_recipe][:id]]
        when ARMOR
          craft = $data_armors[recipe[:prev_recipe][:id]]
        else
          craft = $data_items[recipe[:prev_recipe][:id]]
      end

      return 0 if craft.nil?
      registered = HudellBazaar::get_crafts_registered(craft)
      return 0 if registered < recipe[:prev_recipe][:amount]
    end

    min_amount = nil
    
    recipe[:materials].keys.each do |mat_id|
      # item = $data_items[mat_id]
      number = get_sold_amount(mat_id)

      # number = $game_party.item_number(item)
      return 0 if number < recipe[:materials][mat_id]

      amount = (number / recipe[:materials][mat_id]).floor

      if min_amount.nil?
        min_amount = amount
      else
        min_amount = [min_amount, amount].min
      end
    end

    return 0 if min_amount.nil?
    return min_amount
  end

  def self.open_shop
    goods = get_crafts

    SceneManager.call(Scene_Shop)
    SceneManager.scene.prepare(goods, true)
    Fiber.yield

  end

end

class Scene_Bazaar < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------

  def start
    super
    @goods = nil

    create_help_window
    create_gold_window
    create_command_window
    create_dummy_window
    create_number_window
    create_status_window
    create_buy_window
    create_sell_window
  end

  #--------------------------------------------------------------------------
  # * Create Gold Window
  #--------------------------------------------------------------------------
  def create_gold_window
    @gold_window = Window_Gold.new
    @gold_window.viewport = @viewport
    @gold_window.x = Graphics.width - @gold_window.width
    @gold_window.y = @help_window.height
  end  

  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_ShopCommand.new(@gold_window.x, @purchase_only)
    @command_window.viewport = @viewport
    @command_window.y = @help_window.height
    @command_window.set_handler(:buy,    method(:command_buy))
    @command_window.set_handler(:sell,   method(:command_sell))
    @command_window.set_handler(:cancel, method(:return_scene))
  end

  #--------------------------------------------------------------------------
  # * Create Dummy Window
  #--------------------------------------------------------------------------
  def create_dummy_window
    wy = @command_window.y + @command_window.height
    wh = Graphics.height - wy
    @dummy_window = Window_Base.new(0, wy, Graphics.width, wh)
    @dummy_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Create Quantity Input Window
  #--------------------------------------------------------------------------
  def create_number_window
    wy = @dummy_window.y
    wh = @dummy_window.height
    @number_window = Window_ShopNumber.new(0, wy, wh)
    @number_window.viewport = @viewport
    @number_window.hide
    @number_window.set_handler(:ok,     method(:on_number_ok))
    @number_window.set_handler(:cancel, method(:on_number_cancel))
  end
  #--------------------------------------------------------------------------
  # * Create Status Window
  #--------------------------------------------------------------------------
  def create_status_window
    wx = @number_window.width
    wy = @dummy_window.y
    ww = Graphics.width - wx
    wh = @dummy_window.height
    @status_window = Window_ShopStatus.new(wx, wy, ww, wh)
    @status_window.viewport = @viewport
    @status_window.hide
  end

  #--------------------------------------------------------------------------
  # * Create Purchase Window
  #--------------------------------------------------------------------------
  def create_buy_window
    wy = @dummy_window.y
    wh = @dummy_window.height
    @buy_window = Window_BazaarBuy.new(0, wy, wh, @goods)
    @buy_window.viewport = @viewport
    @buy_window.help_window = @help_window
    @buy_window.status_window = @status_window
    @buy_window.hide
    @buy_window.set_handler(:ok,     method(:on_buy_ok))
    @buy_window.set_handler(:cancel, method(:on_buy_cancel))
  end

  #--------------------------------------------------------------------------
  # * Create Sell Window
  #--------------------------------------------------------------------------
  def create_sell_window
    wy = @dummy_window.y
    wh = @dummy_window.height
    @sell_window = Window_BazaarSell.new(0, wy, Graphics.width, wh)
    @sell_window.viewport = @viewport
    @sell_window.help_window = @help_window
    @sell_window.hide
    @sell_window.set_handler(:ok,     method(:on_sell_ok))
    @sell_window.set_handler(:cancel, method(:on_sell_cancel))
  end

  #--------------------------------------------------------------------------
  # * Activate Purchase Window
  #--------------------------------------------------------------------------
  def activate_buy_window
    @buy_window.money = money
    @buy_window.show.activate
    @status_window.show
  end
  #--------------------------------------------------------------------------
  # * Activate Sell Window
  #--------------------------------------------------------------------------
  def activate_sell_window
    @sell_window.refresh
    @sell_window.show.activate
    @status_window.hide
  end
  #--------------------------------------------------------------------------
  # * [Buy] Command
  #--------------------------------------------------------------------------
  def command_buy
    @dummy_window.hide
    activate_buy_window
  end
  #--------------------------------------------------------------------------
  # * [Sell] Command
  #--------------------------------------------------------------------------
  def command_sell
    @dummy_window.hide
    @sell_window.show
    @sell_window.unselect

    activate_sell_window
    @sell_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * Buy [OK]
  #--------------------------------------------------------------------------
  def on_buy_ok
    @item = @buy_window.item
    @buy_window.hide
    @number_window.set(@item, max_buy, buying_price, currency_unit)
    @number_window.show.activate
  end
  #--------------------------------------------------------------------------
  # * Buy [Cancel]
  #--------------------------------------------------------------------------
  def on_buy_cancel
    @command_window.activate
    @dummy_window.show
    @buy_window.hide
    @status_window.hide
    @status_window.item = nil
    @help_window.clear
  end

  #--------------------------------------------------------------------------
  # * Sell [OK]
  #--------------------------------------------------------------------------
  def on_sell_ok
    @item = @sell_window.item
    @status_window.item = @item
    @sell_window.hide
    @number_window.set(@item, max_sell, selling_price, currency_unit)
    @number_window.show.activate
    @status_window.show
  end
  #--------------------------------------------------------------------------
  # * Sell [Cancel]
  #--------------------------------------------------------------------------
  def on_sell_cancel
    @sell_window.unselect
    @status_window.item = nil
    @help_window.clear

    @command_window.activate
    @dummy_window.show
    @sell_window.hide    
  end
  #--------------------------------------------------------------------------
  # * Quantity Input [OK]
  #--------------------------------------------------------------------------
  def on_number_ok
    Sound.play_shop
    case @command_window.current_symbol
    when :buy
      do_buy(@number_window.number)
    when :sell
      do_sell(@number_window.number)
    end
    end_number_input
    @gold_window.refresh
    @status_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Quantity Input [Cancel]
  #--------------------------------------------------------------------------
  def on_number_cancel
    Sound.play_cancel
    end_number_input
  end
  #--------------------------------------------------------------------------
  # * Execute Purchase
  #--------------------------------------------------------------------------
  def do_buy(number)
    HudellBazaar::register_craft(@item, number)

    $game_party.lose_gold(number * buying_price)
    $game_party.gain_item(@item, number)
  end
  #--------------------------------------------------------------------------
  # * Execute Sale
  #--------------------------------------------------------------------------
  def do_sell(number)
    HudellBazaar::change_sold_amount(@item.id, number)
    $game_party.gain_gold(number * selling_price)
    $game_party.lose_item(@item, number)
  end

  #--------------------------------------------------------------------------
  # * Exit Quantity Input
  #--------------------------------------------------------------------------
  def end_number_input
    @number_window.hide
    case @command_window.current_symbol
    when :buy
      activate_buy_window
    when :sell
      activate_sell_window
    end
  end
  #--------------------------------------------------------------------------
  # * Get Maximum Quantity Buyable
  #--------------------------------------------------------------------------
  def max_buy
    max = $game_party.max_item_number(@item) - $game_party.item_number(@item) 
    max_crafts = HudellBazaar::get_max_crafts(@item)
    max = [max, max_crafts].min

    buying_price == 0 ? max : [max, money / buying_price].min
  end
  #--------------------------------------------------------------------------
  # * Get Maximum Quantity Sellable
  #--------------------------------------------------------------------------
  def max_sell
    $game_party.item_number(@item)
  end
  #--------------------------------------------------------------------------
  # * Get Party Gold
  #--------------------------------------------------------------------------
  def money
    @gold_window.value
  end
  #--------------------------------------------------------------------------
  # Get Currency Unit
  #--------------------------------------------------------------------------
  def currency_unit
    @gold_window.currency_unit
  end
  #--------------------------------------------------------------------------
  # * Get Purchase Price
  #--------------------------------------------------------------------------
  def buying_price
    @buy_window.price(@item)
  end
  #--------------------------------------------------------------------------
  # * Get Sale Price
  #--------------------------------------------------------------------------
  def selling_price
    @item.price / 2
  end
end

class Window_BazaarSell < Window_ShopSell
  def make_item_list
    @data = $game_party.all_items.select {|item| item.is_a?(RPG::Item) && HudellBazaar::item_is_material?(item.id) }
  end
end

class Window_BazaarBuy < Window_ShopBuy
  alias bazaar_enable? enable?
  def enable?(item)
    return false unless bazaar_enable?(item)
    return HudellBazaar::get_max_crafts(item) > 0
  end 

  alias bazaar_make_item_list make_item_list
  def make_item_list
    @shop_goods = HudellBazaar::get_crafts
    bazaar_make_item_list
  end
end

class Window_ItemCategory < Window_HorzCommand
  def col_max
    return 5
  end

  def make_command_list
    add_command(Vocab::item, :item)
    add_command(Vocab::weapon, :weapon)
    add_command(Vocab::armor, :armor)
    add_command('Materials', :materials)
    add_command(Vocab::key_item, :key_item)
  end  
end

class Window_ShopItemCategory < Window_ItemCategory
  def col_max
    return 4
  end

  def make_command_list
    add_command(Vocab::item, :item)
    add_command(Vocab::weapon, :weapon)
    add_command(Vocab::armor, :armor)
    add_command(Vocab::key_item, :key_item)
  end  
end

class Window_ItemList < Window_Selectable
  alias bazaar_include? include?
  def include?(item)
    case @category
    when :materials
      item.is_a?(RPG::Item) && HudellBazaar::item_is_material?(item.id)
    when :item
      item.is_a?(RPG::Item) && !item.key_item? && !HudellBazaar::item_is_material?(item.id)
    when :key_item
      item.is_a?(RPG::Item) && item.key_item? && !HudellBazaar::item_is_material?(item.id)
    else
      bazaar_include?(item)
    end
  end
end

class Scene_Shop < Scene_MenuBase
  def create_category_window
    @category_window = Window_ShopItemCategory.new
    @category_window.viewport = @viewport
    @category_window.help_window = @help_window
    @category_window.y = @dummy_window.y
    @category_window.hide.deactivate
    @category_window.set_handler(:ok,     method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:on_category_cancel))
  end  
end
