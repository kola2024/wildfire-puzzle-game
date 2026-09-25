package fire

import "core:encoding/json"
import "/utils"

unmarshal_manifest :: proc() -> Manifest {
	data, ok := utils.read_entire_file("../../assets/manifest.json", context.temp_allocator)
    if !ok do log233332("file read err: file at path not found")

    m: Manifest

	err := json.unmarshal(data, &m)
    if err != nil do log233332("file unmarshal err:", err)

	return m
}

marshal_json :: proc() {

    j := Manifest{
        levels = make([dynamic]LevelInfo, context.temp_allocator),
    }

    g := make([dynamic]string, context.temp_allocator)
    append(&g, "10001")
    append(&g, "00001")

    append(&j.levels, LevelInfo{
        id = 1,
        name = "test",
        size = {5, 2},
        grid = g,
    })

	json_bytes, json_err := json.marshal(j, allocator = context.temp_allocator)
	if json_err != nil do log233332("err marshal json: path")

	ok := utils.write_entire_file("../../assets/manifest.json", json_bytes)
	if !ok do log233332("err marshal json: data:")
}

manifest_levelinfo_to_grid :: proc(w: ^World) {
    clear(&w.level.grid)
    //current_level := w.manifest.levels[w.level_index] //current_level.size.x*current_level.size.y
    for xstring in w.manifest.levels[w.level_index].grid {
        for ychar in xstring {
            append(&w.level.grid, Object(ychar))//grid_stream[x*int(current_level.size.y)+y] = Object(ychar)
        }
    }
    log233332(w.level)
}