package fire

import "core:encoding/json"
import "/utils"

JLevel :: struct{
    id: i32,
    name: cstring,
    size: Vec2,
    grid: [dynamic]string,
} 

Manifest :: struct{
    levels: [dynamic]JLevel,
}

unmarshal_manifest :: proc() -> Manifest {
	data, ok := utils.read_entire_file("../../assets/levels/manifest.json", context.temp_allocator)
    if !ok do log233332("file read err: file at path not found")

    m: Manifest

	err := json.unmarshal(data, &m)
    if err != nil do log233332("file unmarshal err:", err)

	return m
}

marshal_json :: proc() {

    j := Manifest{
        levels = make([dynamic]JLevel, context.temp_allocator),
    }

    g := make([dynamic]string, context.temp_allocator)
    append(&g, "10001")
    append(&g, "00001")

    append(&j.levels, JLevel{
        id = 1,
        name = "test",
        size = {5, 2},
        grid = g,
    })

	json_bytes, json_err := json.marshal(j, allocator = context.temp_allocator)
	if json_err != nil do log233332("err marshal json: path")

	ok := utils.write_entire_file("../../assets/levels/manifest.json", json_bytes)
	if !ok do log233332("err marshal json: data:")
}