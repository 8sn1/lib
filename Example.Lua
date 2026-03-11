local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/8sn1/lib/main/Library.Lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/8sn1/lib/main/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/8sn1/lib/main/SaveManager.lua'))()

-- Create the main window with left‑side tabs (you can change to "up", "down", "left", "right")
local Window = Library:CreateWindow({
    Title = 'Linoria',
    Version = 'version you want',
    VersionColor = Color3.fromRGB(0, 255, 255),
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
    TabsPlacement = "left", -- try "up", "down", "left", "right"
})

-- Create tabs
local Tabs = {
    Main = Window:AddTab('Main'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Groupbox')

-- We can also get our Main tab via the following code:
-- local LeftGroupBox = Window.Tabs.Main:AddLeftGroupbox('Groupbox')

-- Tabboxes are a tiny bit different, but here's a basic example:
--[[

local TabBox = Tabs.Main:AddLeftTabbox() -- Add Tabbox on left side

local Tab1 = TabBox:AddTab('Tab 1')
local Tab2 = TabBox:AddTab('Tab 2')

-- You can now call AddToggle, etc on the tabs you added to the Tabbox
]]

-- Groupbox:AddToggle
-- Arguments: Index, Options
LeftGroupBox:AddToggle('MyToggle', {
    Text = 'This is a toggle',
    Default = true, -- Default value (true / false)
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the toggle

    Callback = function(Value)
        print('[cb] MyToggle changed to:', Value)
    end
})


-- Fetching a toggle object for later use:
-- Toggles.MyToggle.Value

-- Toggles is a table added to getgenv() by the library
-- You index Toggles with the specified index, in this case it is 'MyToggle'
-- To get the state of the toggle you do toggle.Value

-- Calls the passed function when the toggle is updated
Toggles.MyToggle:OnChanged(function()
    -- here we get our toggle object & then get its value
    print('MyToggle changed to:', Toggles.MyToggle.Value)
end)

-- This should print to the console: "My toggle state changed! New value: false"
Toggles.MyToggle:SetValue(false)

-- Deprecated old way of creating buttons in favor of using a table
-- Added DoubleClick button functionality

--[[
    Groupbox:AddButton
    Arguments: {
        Text = string,
        Func = function,
        DoubleClick = boolean
        Tooltip = string,
    }

    You can call :AddButton on a button to add a SubButton!
]]

local MyButton = LeftGroupBox:AddButton({
    Text = 'Button',
    Func = function()
        Library:Notify('You clicked the main button!')
        print('You clicked a button!')
    end,
    DoubleClick = false,
    Tooltip = 'This is the main button'
})

local MyButton2 = MyButton:AddButton({
    Text = 'Sub button',
    Func = function()
        print('You clicked a sub button!')
    end,
    DoubleClick = true, -- You will have to click this button twice to trigger the callback
    Tooltip = 'This is the sub button (double click me!)'
})

--[[
    NOTE: You can chain the button methods!
    EXAMPLE:

    LeftGroupBox:AddButton({ Text = 'Kill all', Func = Functions.KillAll, Tooltip = 'This will kill everyone in the game!' })
        :AddButton({ Text = 'Kick all', Func = Functions.KickAll, Tooltip = 'This will kick everyone in the game!' })
]]

-- Groupbox:AddLabel
-- Arguments: Text, DoesWrap
LeftGroupBox:AddLabel('This is a label')
LeftGroupBox:AddLabel('This is a label\n\nwhich wraps its text!', true)

-- Groupbox:AddDivider
-- Arguments: None
LeftGroupBox:AddDivider()

--[[
    Groupbox:AddSlider
    Arguments: Idx, SliderOptions

    SliderOptions: {
        Text = string,
        Default = number,
        Min = number,
        Max = number,
        Suffix = string,
        Rounding = number,
        Compact = boolean,
        HideMax = boolean,
    }

    Text, Default, Min, Max, Rounding must be specified.
    Suffix is optional.
    Rounding is the number of decimal places for precision.

    Compact will hide the title label of the Slider

    HideMax will only display the value instead of the value & max value of the slider
    Compact will do the same thing
]]
LeftGroupBox:AddSlider('MySlider', {
    Text = 'This is my slider!',
    Default = 0,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        print('[cb] MySlider was changed! New value:', Value)
    end
})

-- Options is a table added to getgenv() by the library
-- You index Options with the specified index, in this case it is 'MySlider'
-- To get the value of the slider you do slider.Value

local Number = Options.MySlider.Value
Options.MySlider:OnChanged(function()
    print('MySlider was changed! New value:', Options.MySlider.Value)
end)

-- This should print to the console: "MySlider was changed! New value: 3"
Options.MySlider:SetValue(3)

-- Example: add a sub-slider (slider inside a slider)
-- You can call :AddSlider on a slider to create a horizontally-arranged child slider
local ParentSlider = Options.MySlider
local SubSlider = ParentSlider:AddSlider('MySubSlider', {
    Text = 'Sub slider',
    Default = 1,
    Min = 0,
    Max = 5,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
        print('[cb] MySubSlider was changed! New value:', Value)
    end
})

-- React to changes on the sub-slider
Options.MySubSlider:OnChanged(function()
    print('MySubSlider changed to:', Options.MySubSlider.Value)
end)

-- Groupbox:AddInput
-- Arguments: Idx, Info
LeftGroupBox:AddInput('MyTextbox', {
    Default = 'My textbox!',
    Numeric = false, -- true / false, only allows numbers
    Finished = false, -- true / false, only calls callback when you press enter

    Text = 'This is a textbox',
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the textbox

    Placeholder = 'Placeholder text', -- placeholder text when the box is empty
    -- MaxLength is also an option which is the max length of the text

    Callback = function(Value)
        print('[cb] Text updated. New text:', Value)
    end
})

Options.MyTextbox:OnChanged(function()
    print('Text updated. New text:', Options.MyTextbox.Value)
end)

-- Groupbox:AddDropdown
-- Arguments: Idx, Info

LeftGroupBox:AddDropdown('MyDropdown', {
    Values = { 'This', 'is', 'a', 'dropdown' },
    Default = 1, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'A dropdown',
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown

    Callback = function(Value)
        print('[cb] Dropdown got changed. New value:', Value)
    end
})

Options.MyDropdown:OnChanged(function()
    print('Dropdown got changed. New value:', Options.MyDropdown.Value)
end)

Options.MyDropdown:SetValue('This')

-- Multi dropdowns
LeftGroupBox:AddDropdown('MyMultiDropdown', {
    -- Default is the numeric index (e.g. "This" would be 1 since it if first in the values list)
    -- Default also accepts a string as well

    -- Currently you can not set multiple values with a dropdown

    Values = { 'This', 'is', 'a', 'dropdown' },
    Default = 1,
    Multi = true, -- true / false, allows multiple choices to be selected

    Text = 'A dropdown',
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown

    Callback = function(Value)
        print('[cb] Multi dropdown got changed:', Value)
    end
})

Options.MyMultiDropdown:OnChanged(function()
    -- print('Dropdown got changed. New value:', )
    print('Multi dropdown got changed:')
    for key, value in next, Options.MyMultiDropdown.Value do
        print(key, value) -- should print something like This, true
    end
end)

Options.MyMultiDropdown:SetValue({
    This = true,
    is = true,
})

LeftGroupBox:AddDropdown('MyPlayerDropdown', {
    SpecialType = 'Player',
    Text = 'A player dropdown',
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown

    Callback = function(Value)
        print('[cb] Player dropdown got changed:', Value)
    end
})

-- Label:AddColorPicker
-- Arguments: Idx, Info

-- You can also ColorPicker & KeyPicker to a Toggle as well

LeftGroupBox:AddLabel('Color'):AddColorPicker('ColorPicker', {
    Default = Color3.new(0, 1, 0), -- Bright green
    Title = 'Some color', -- Optional. Allows you to have a custom color picker title (when you open it)
    Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

    Callback = function(Value)
        print('[cb] Color changed!', Value)
    end
})

Options.ColorPicker:OnChanged(function()
    print('Color changed!', Options.ColorPicker.Value)
    print('Transparency changed!', Options.ColorPicker.Transparency)
end)

Options.ColorPicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

-- Label:AddKeyPicker
-- Arguments: Idx, Info

LeftGroupBox:AddLabel('Keybind'):AddKeyPicker('KeyPicker', {
    -- SyncToggleState only works with toggles.
    -- It allows you to make a keybind which has its state synced with its parent toggle

    -- Example: Keybind which you use to toggle flyhack, etc.
    -- Changing the toggle disables the keybind state and toggling the keybind switches the toggle state

    Default = 'MB2', -- String as the name of the keybind (MB1, MB2 for mouse buttons)
    SyncToggleState = false,


    -- You can define custom Modes but I have never had a use for it.
    Mode = 'Toggle', -- Modes: Always, Toggle, Hold

    Text = 'Auto lockpick safes', -- Text to display in the keybind menu
    NoUI = false, -- Set to true if you want to hide from the Keybind menu,

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function(Value)
        print('[cb] Keybind clicked!', Value)
    end,

    -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
    ChangedCallback = function(New)
        print('[cb] Keybind changed!', New)
    end
})

-- OnClick is only fired when you press the keybind and the mode is Toggle
-- Otherwise, you will have to use Keybind:GetState()
Options.KeyPicker:OnClick(function()
    print('Keybind clicked!', Options.KeyPicker:GetState())
end)

Options.KeyPicker:OnChanged(function()
    print('Keybind changed!', Options.KeyPicker.Value)
end)

task.spawn(function()
    while true do
        wait(1)

        -- example for checking if a keybind is being pressed
        local state = Options.KeyPicker:GetState()
        if state then
            print('KeyPicker is being held down')
        end

        if Library.Unloaded then break end
    end
end)

Options.KeyPicker:SetValue({ 'MB2', 'Toggle' }) -- Sets keybind to MB2, mode to Hold

-- Long text label to demonstrate UI scrolling behaviour.
local LeftGroupBox2 = Tabs.Main:AddLeftGroupbox('Groupbox #2');
LeftGroupBox2:AddLabel('Oh no...\nThis label spans multiple lines!\n\nWe\'re gonna run out of UI space...\nJust kidding! Scroll down!\n\n\n\n\nHello from below!', true)

local TabBox = Tabs.Main:AddRightTabbox() -- Add Tabbox on right side

-- Anything we can do in a Groupbox, we can do in a Tabbox tab (AddToggle, AddSlider, AddLabel, etc etc...)
local Tab1 = TabBox:AddTab('Tab 1')
Tab1:AddToggle('Tab1Toggle', { Text = 'Tab1 Toggle' });

local Tab2 = TabBox:AddTab('Tab 2')
Tab2:AddToggle('Tab2Toggle', { Text = 'Tab2 Toggle' });

-- Dependency boxes let us control the visibility of UI elements depending on another UI elements state.
-- e.g. we have a 'Feature Enabled' toggle, and we only want to show that features sliders, dropdowns etc when it's enabled!
-- Dependency box example:
local RightGroupbox = Tabs.Main:AddRightGroupbox('Groupbox #3');
RightGroupbox:AddToggle('ControlToggle', { Text = 'Dependency box toggle' });

local Depbox = RightGroupbox:AddDependencyBox();
Depbox:AddToggle('DepboxToggle', { Text = 'Sub-dependency box toggle' });

-- We can also nest dependency boxes!
-- When we do this, our SupDepbox automatically relies on the visiblity of the Depbox - on top of whatever additional dependencies we set
local SubDepbox = Depbox:AddDependencyBox();
SubDepbox:AddSlider('DepboxSlider', { Text = 'Slider', Default = 50, Min = 0, Max = 100, Rounding = 0 });
SubDepbox:AddDropdown('DepboxDropdown', { Text = 'Dropdown', Default = 1, Values = {'a', 'b', 'c'} });

Depbox:SetupDependencies({
    { Toggles.ControlToggle, true } -- We can also pass `false` if we only want our features to show when the toggle is off!
});

SubDepbox:SetupDependencies({
    { Toggles.DepboxToggle, true }
});

-- -------------------- RAGEBOT GROUPBOX (fixed layout) --------------------
local ragebot = Tabs.Main:AddRightGroupbox('ragebot')

local ragebotenable = ragebot:AddToggle('Ragebot', {
    Text = 'enabled',
    Default = false,
})

-- Add a color picker – it will appear to the right of the toggle text
ragebotenable:AddColorPicker('RagebotColor', {
    Default = Color3.fromRGB(255, 100, 100),
    Transparency = 0,
    Title = 'Ragebot color',
    Callback = function(value)
        print('Ragebot color changed:', value)
    end
})

-- Add a key picker – it will appear next to the color picker
ragebotenable:AddKeyPicker('RagebotKey', {
    Default = 'F',               -- must be a valid key (e.g., 'F', 'MB1', 'E')
    Mode = 'Toggle',             -- 'Toggle', 'Hold', or 'Always'
    SyncToggleState = true,      -- synchronises with the parent toggle's state
    Text = 'Ragebot key',        -- description shown in the keybind list
    NoUI = false,                -- set to true to hide from the keybind list
})

-- -------------------- OTHER STANDARD CONTROLS --------------------
local LeftGroup2 = Tabs.Main:AddRightGroupbox('Standard Controls')
LeftGroup2:AddToggle('MyToggle', { Text = 'Master Toggle', Default = true })
LeftGroup2:AddSlider('MySlider', {
    Text = 'Power Level',
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%'
})
LeftGroup2:AddInput('MyInput', {
    Text = 'Username',
    Default = 'Player1',
    Placeholder = 'Enter name'
})
LeftGroup2:AddDropdown('MyDropdown', {
    Text = 'Choose an option',
    Values = { 'Option A', 'Option B', 'Option C' },
    Default = 1
})

-- -------------------- DEPENDENCY DEMO --------------------
local RightGroup2 = Tabs.Main:AddRightGroupbox('Dropdown Dependency Demo')
RightGroup2:AddDropdown('DependencyDropdown', {
    Text = 'Pick a value',
    Values = { 'random spiral', 'other value', 'something else' },
    Default = 2,
})
local DepBox = RightGroup2:AddDependencyBox()
DepBox:AddToggle('SecretToggle', { Text = 'Secret toggle' })
DepBox:AddSlider('SecretSlider', { Text = 'Secret slider', Default = 10, Min = 0, Max = 20, Rounding = 0 })
DepBox:SetupDependencies({ { Options.DependencyDropdown, "random spiral" } })
RightGroup2:AddLabel('This label is always visible')

-- -------------------- UI SETTINGS TAB --------------------
local UIGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu Settings')

-- Notification bar position dropdown
UIGroup:AddDropdown('NotificationBarPosition', {
    Values = { 'Left', 'Top', 'Bottom', 'Right' },
    Default = 1,
    Text = 'Notification bar position',
    Callback = function(Value)
        Library.NotificationStyle.BarSide = Value
    end
})

-- Notification alignment dropdown
UIGroup:AddDropdown('NotificationPosition', {
    Values = { 'Left', 'Center', 'Right' },
    Default = 1,
    Text = 'Notification position',
    Callback = function(Value)
        Library.NotificationStyle.Alignment = Value
    end
})

-- Notification X offset slider
UIGroup:AddSlider('NotificationX', {
    Text = 'Notification X position',
    Default = 0,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '',
    Callback = function(Value)
        Library.NotificationStyle.X = Value / 100
    end
})

-- Notification Y offset slider
UIGroup:AddSlider('NotificationY', {
    Text = 'Notification Y position',
    Default = 10,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '',
    Callback = function(Value)
        Library.NotificationStyle.Y = Value / 100
    end
})

-- Keybind list mode dropdown
UIGroup:AddDropdown('KeybindListMode', {
    Text = 'Keybind list mode',
    Values = { 'All', 'Active', 'Toggled' },
    Default = 1,
    Callback = function(v)
        Library.KeypickerListMode = v
        Library:UpdateKeybindList()
    end
})

-- Toggle for keybind menu visibility
UIGroup:AddToggle('KeybindMenuToggle', {
    Text = 'Show keybind menu',
    Default = true,
    Callback = function(v)
        Library.KeypickerListVisible = v
        Library:UpdateKeybindList()
    end
})

-- Font selector (20+ fonts)
local fontNames = {}
for _, pair in ipairs(Library.Fonts) do
    table.insert(fontNames, pair[1])
end
UIGroup:AddDropdown('UIFont', {
    Text = 'UI Font',
    Values = fontNames,
    Default = 1,
    Callback = function(fontName)
        Library:SetFont(fontName)
    end
})

-- Test notification button
UIGroup:AddButton('Test Notification', function()
    Library:Notify('This is a test notification!', 3)
end)

-- Unload button
UIGroup:AddButton('Unload', function() Library:Unload() end)

-- Menu keybind (hidden from keybind list)
UIGroup:AddLabel('Menu toggle'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true })
Library.ToggleKeybind = Options.MenuKeybind

-- -------------------- THEME & SAVE MANAGERS --------------------
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore theme settings when saving configs
SaveManager:IgnoreThemeSettings()

-- Do not save the menu keybind in configs
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

-- Set folders for themes and configs
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')

-- Build the config menu on the right side of the UI Settings tab
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- Apply the theme menu to the left side of the UI Settings tab
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- Automatically load the last used config
SaveManager:LoadAutoloadConfig()
