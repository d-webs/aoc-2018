const fs = require('fs');
const TIMESTAMP_REGEX = /\[\d+-(?<date>.+)\]/u
const GUARD_ID_REGEX = /\].+(?<guardId>#\d+).+$/

class Day4 {
  constructor(inputPath) {
    this.inputPath = inputPath;
    this.rootNode = null;
  }

  run() {
    const data = fs.readFileSync(this.inputPath);
    const events = data.toString().split(/\n/);

    const sortedEvents = events.sort((line1, line2) => {
      const { groups: { date: ts1 } } = TIMESTAMP_REGEX.exec(line1);
      const { groups: { date: ts2 } } = TIMESTAMP_REGEX.exec(line2);

      const date1 = new Date(ts1);
      const date2 = new Date(ts2);

      if (date1 < date2) {
        return -1
      }
      if (date1 > date2) {
        return 1
      }
      return 0;
    })
    
    //   console.log(line.toString());
  
    //   if (lineData) { 
    //     // const guardId = line.toString().match(GUARD_ID_REGEX);
    //     const { groups: date } = lineData
    //     // const event = new Event(date);
        
    //     if (!this.rootNode) {
    //       this.rootNode = new BSTNode(date);
    //     } else {
    //       this.rootNode.insert(new BSTNode(date));
    //     }
    //   };

    // });
    null
  }
}

new Day4('./input.txt').run();
// data = fs.readFileSync('./input.txt');
// console.log(data.toString().split(/\n/));
