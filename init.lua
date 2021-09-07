
function technomagic_get_hipotenuse_value(point1, point2)
    return math.sqrt((point1.x - point2.x) ^ 2 + (point1.y - point2.y) ^ 2 + (point1.z - point2.z) ^ 2)
end

minetest.register_entity("technomagic:circle", {
	initial_properties = {
	    physical = true,
	    collisionbox = {0,0,0,0,0,0},
	    visual = "mesh",
	    mesh = "technomagic_circle.obj",
        textures = {"technomagic_circle.png^[multiply:#06B5DD"},
    },
    textures = {},
	timer = 0,
	glow = 15,
    owner = nil,
    position = nil,
	visual_size = {x = 8, y = 8, z = 8},

	on_step = function(self, dtime)
        if self.owner then
            local player = minetest.get_player_by_name(self.owner)
            local pos = player:get_pos()
            local distance = math.abs(technomagic_get_hipotenuse_value(pos, self.position))

            if distance > 4 then
		        self.timer = self.timer + dtime
		        -- remove after set number of seconds
		        if self.timer > 5 then
			        self.object:remove()
		        end
            end
        end
	end,
})



minetest.register_chatcommand("circle", {
    func = function(name, param)
        local magic_word = param
        
        local player = minetest.get_player_by_name(name)
        local pos = player:get_pos()


        if magic_word == "ieaou" then
            local circle = minetest.add_entity(pos, "technomagic:circle")
		    if circle and player then
                local ent = circle:get_luaentity()
                local owner = player:get_player_name()
                ent.position = pos
                ent.owner = owner
		    end
        end

        if magic_word == "uoaei" then
            --lets detect any circle at this radius and remove it
            local radius_objects = minetest.get_objects_inside_radius(pos, 5)
            for _, object in ipairs(radius_objects) do
                if object then
                    local pos = object:get_pos()
                    local entity = object:get_luaentity()
                    if entity then
                        if entity.name == "technomagic:circle" then
                            entity.object:remove()
                        end
                    end
                end
            end

        end
    end,
})
