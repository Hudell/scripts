$imported ||= {}
$imported[:HudellBazaar_Recipes] = 1.0

module HudellBazaar
    #You can add item and weapon codes here to make it easier to read the recipes

    #items
    POTION = 1
    HI_POTION = 2
    FULL_POTION = 3
    ANTIDOTE = 6

    #weapons
    HAND_AX = 1
    SHORT_SWORD = 19

    #armors
    CASUAL_CLOTHES = 1
    LEATHER_TOP = 2

    RECIPES = [
        #Recipe for High Potion (5 Potions)
        {
            :type => ITEM,
            :id => HI_POTION,
            :materials => {
                POTION => 5
            }
        },

        #Recipe for Full Potion (10 Potions and you need to have made a Hi potion before)
        {
            :type => ITEM,
            :id => FULL_POTION,
            :materials => {
                POTION => 10
            },
            :prev_recipe => {
                :type => ITEM,
                :id => HI_POTION,
                :amount => 1
            }
        },

        #Recipe for Hand Ax (2 Hi Potions)
        {
            :type => WEAPON,
            :id => HAND_AX,
            :materials => {
                HI_POTION => 2
            }
        },

        #Recipe for Short Sword (2 Antidotes)
        {
            :type => WEAPON,
            :id => SHORT_SWORD,
            :materials => {
                ANTIDOTE => 2
            }
        },

        #Recipe for Casual Clothes (10 potions and 10 antidotes)
        {
            :type => ARMOR,
            :id => CASUAL_CLOTHES,
            :materials => {
                POTION => 10,
                ANTIDOTE => 10
            }
        },

        #Recipe for Leather Top (1 Full Potion)
        {
            :type => ARMOR,
            :id => LEATHER_TOP,
            :materials => {
                FULL_POTION => 1
            }
        }
    ]
end
