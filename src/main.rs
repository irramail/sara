extern crate redis;

use redis::{Commands};
use jsonrpc_http_server::jsonrpc_core::{IoHandler, Value, Params, Error};
use jsonrpc_http_server::{ServerBuilder};

fn parse_arguments (p: Params) -> Result<Vec<String>, Error> {
  let mut result = Vec::new();
  match p {
    Params::Array(array) => {
      for s in &array {
        match s {
          Value::String(s) => result.push(s.clone()),
          _ => return Err(Error::invalid_params("expecting strings"))
        }
      }
    }
    _ => return Err(Error::invalid_params("expecting an array of strings"))
  }
  if result.len() < 1 {
    return Err(Error::invalid_params("missing api key"));
  }

  return Ok(result[0..].to_vec());
}

fn set_text(mpgatext: &str) -> redis::RedisResult<isize> {
  let client = redis::Client::open("redis://127.0.0.1/")?;
  let mut con = client.get_connection()?;

  let _ : () = con.set("mpgatext", mpgatext)?;
  let _ : () = con.set("mpgastext", mpgatext)?;

  con.get("mpgatext")
}

fn get_text() -> redis::RedisResult<String> {
  let client = redis::Client::open("redis://127.0.0.1/")?;
  let mut con = client.get_connection()?;

  con.get("mpgabtext")
}

fn get_stext() -> redis::RedisResult<String> {
  let client = redis::Client::open("redis://127.0.0.1/")?;
  let mut con = client.get_connection()?;

  con.get("mpgastext")
}

fn set_zero_text() -> redis::RedisResult<isize> {
  let client = redis::Client::open("redis://127.0.0.1/")?;
  let mut con = client.get_connection()?;

  let _ : () = con.set("mpgabtext", "")?;
  let _ : () = con.set("mpgastext", "")?;


  con.get("mpgabtext")
}

fn main() {
  let mut io = IoHandler::new();

  let _ = set_zero_text();

  io.add_method("set_text",  move |params: Params| {
    let w = parse_arguments(params)?;
    let _ = set_text(&w[0]);

    Ok(Value::String("".to_string()))
  });

  io.add_method("get_text",  | _params | {
    let text = get_text().unwrap();

    Ok(Value::String(text))
  });

  io.add_method("get_stext",  | _params | {
    let text = get_stext().unwrap();

    Ok(Value::String(text))
  });

  let server = ServerBuilder::new(io)
    .threads(3)
    .start_http(&"127.0.0.1:3031".parse().unwrap())
    .unwrap();

  server.wait();
}
