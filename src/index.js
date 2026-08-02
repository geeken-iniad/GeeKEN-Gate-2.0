import * as glen from "../glen/glen.mjs";
import * as geeken_gate_gleam from "./geeken_gate_gleam.mjs";

export default {
  async fetch(request, _env, _ctx) {
    const req = glen.convert_request(request);
    const response = await geeken_gate_gleam.handle_req(req);
    const res = glen.convert_response(response);

    return res;
  },
};
