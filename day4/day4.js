const fs = require('fs');
const TIMESTAMP_REGEX = /\[(?<yr>\d{4})-(?<mo>\d{2})-(?<day>\s{2})\s*(?<hr>\d{2}):(?<min>\d{2})\]/u
const GUARD_ID_REGEX = /\].+(?<guardId>#\d+).+$/

class BSTNode {
  constructor(event) {
    this.left, this.right = null, null;
  }

  insert(event) {

  }
}

class Day4 {
  constructor(inputPath) {
    this.inputPath = inputPath;
    this.rootNode = null;
  }

  run() {
    fs.readFile(this.inputPath, (_err, line) => {
      console.log(line.toString());
      const lineData = TIMESTAMP_REGEX.exec(line.toString());
  
      if (lineData) { 
        // const guardId = line.toString().match(GUARD_ID_REGEX);
        const { groups } = lineData
        const event = new Event(groups);
        
        if (this.rootNode === null) {
          this.rootNode = new BSTNode(event)
          console.log(this.rootNode);
        }
      };

    });
  }
}

class Event {
  constructor({ yr, mo, day, hr, min }) {
    this.yr = yr;
    this.mo = mo;
    this.day = day;
    this.hr = hr;
    this.min = min;
  }
}

class Guard {

}

new Day4('./input.txt').run();