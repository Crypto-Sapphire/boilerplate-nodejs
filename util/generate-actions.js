const yaml = require("yaml-js");
const { readFileSync, writeFileSync } = require('fs');
const yml = readFileSync(__dirname + '/../serverless.yml', 'utf-8');
const obj = yaml.load(yml);
const names = [];

for (let fn of Object.values(obj.functions||{})) {
  if (!fn.handler) {
    continue
  }

  names.push(fn.handler.split(/\./g).pop())
}

writeFileSync(__dirname + '/../config/_actions.json', JSON.stringify(names));
