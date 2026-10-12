-- lua_examples.lua
--
-- 10 small Lua examples
-- Run with:
--     lua lua_examples.lua
--
-- Or load it from Neovim with:
--     :luafile lua_examples.lua

-- ============================================================
-- 1. Numbers and arithmetic
-- ============================================================

local a = 10
local b = 3

print("1. Numbers")
print("addition:", a + b)
print("subtraction:", a - b)
print("multiplication:", a * b)
print("division:", a / b)
print("remainder:", a % b)
print("power:", a ^ b)

print()

-- ============================================================
-- 2. Strings and characters
-- ============================================================

local name = "Jonas"
local letter = "ä"

print("2. Strings")
print("name:", name)
print("first character:", name:sub(1, 1))
print("letter:", letter)
print("length:", #name)

local greeting = "Hello, " .. name
print(greeting)

print()


-- ============================================================
-- 3. Lists
-- ============================================================

local fruits = {
	"apple",
	"banana",
	"orange",
	"pear",
}

print("3. List")

print("first:", fruits[1])
print("second:", fruits[2])
print("number of items:", #fruits)

for i, fruit in ipairs(fruits) do
	print(i, fruit)
end

print()


-- ============================================================
-- 4. Adding/removing items from a list
-- ============================================================

local numbers = { 10, 20, 30 }

table.insert(numbers, 40)
table.insert(numbers, 50)

print("4. List modification")

for _, n in ipairs(numbers) do
	print(n)
end

table.remove(numbers, 2)

print("after removing item 2:")

for _, n in ipairs(numbers) do
	print(n)
end

print()


-- ============================================================
-- 5. Maps / dictionaries
-- ============================================================

local person = {
	name = "Jonas",
	age = 42,
	country = "Sweden",
}

print("5. Map")

print("name:", person.name)
print("age:", person.age)
print("country:", person.country)

-- Another way to access a key
print("name:", person["name"])

print()


-- ============================================================
-- 6. Looping over a map
-- ============================================================

local colors = {
	red = "#ff0000",
	green = "#00ff00",
	blue = "#0000ff",
}

print("6. Map iteration")

for key, value in pairs(colors) do
	print(key, value)
end

print()


-- ============================================================
-- 7. Functions
-- ============================================================

local function square(n)
	return n * n
end

local function add(x, y)
	return x + y
end

print("7. Functions")

print("square:", square(8))
print("add:", add(10, 20))

print()


-- ============================================================
-- 8. Conditionals and loops
-- ============================================================

print("8. Conditionals")

for i = 1, 10 do
	if i % 2 == 0 then
		print(i, "even")
	else
		print(i, "odd")
	end
end

print()


-- ============================================================
-- 9. Map/filter-style operations
-- ============================================================

local values = { 1, 2, 3, 4, 5 }

local doubled = {}

for _, value in ipairs(values) do
	table.insert(doubled, value * 2)
end

print("9. Transforming a list")

print("original:")

for _, value in ipairs(values) do
	print(value)
end

print("doubled:")

for _, value in ipairs(doubled) do
	print(value)
end

print()

-- ============================================================
-- 10. Nested maps and lists
-- ============================================================

local people = {
	{
		name = "Alice",
		age = 30,
		languages = { "Lua", "Python" },
	},

	{
		name = "Bob",
		age = 25,
		languages = { "C", "Rust", "Lua" },
	},

	{
		name = "Carol",
		age = 35,
		languages = { "Python", "JavaScript" },
	},
}

print("10. Nested data")

for _, person in ipairs(people) do
	print(person.name, person.age)

	print("languages:")

	for _, language in ipairs(person.languages) do
		print("  ", language)
	end
end

print()

-- ============================================================
-- Bonus: a useful Lua pattern
-- ============================================================

local function factorial(n)
	local result = 1

	for i = 2, n do
		result = result * i
	end

	return result
end

print("Bonus")
print("factorial(8):", factorial(8))

local function fact(n)
    if n <= 1 then
        return 1
    end

    return n * fact(n - 1)
end

return {
    fact = fact,
}


