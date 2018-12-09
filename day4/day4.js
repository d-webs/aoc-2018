const fs = require('fs')
const { Map, List } = require('immutable')
const R = require('rambda')

/*
** Regular Expressions
*/
const TIMESTAMP_REGEX = /\[\d+-(?<date>.+)\]/
const GUARD_REGEX = /\].+#(?<id>\d+).+$/


// const sortByVal = h => (
//   Object.keys(h).sort((k1, k2) => (
//     h[k1] > h[k2] ? 1 : 
//       h[k1] < h[k2] ? 
//         -1 : 
//         0
//   ))
// )

/*
** File I/O
*/
const getLines = path => (
  fs.readFileSync(path)
    .toString()
    .split(/\n/)
)

/*
** Matching Functions
*/
const constructMatcher = regex => line => R.match(regex, line) //regex.exec(line) || {}
const getMatchGroup = property => ({ groups = {} }) => groups[property]

/*
** String Parsing
*/
const getMinutes = R.pipe(
  str => R.split(":", str),
  R.last,
  parseInt,
  n => n % 60
)

const getTime = R.pipe(constructMatcher(TIMESTAMP_REGEX), getMatchGroup('date'))
const getGuard = R.pipe(constructMatcher(GUARD_REGEX), getMatchGroup('id'))

/*
 * Sorting
 */
const sortByTime = arr => arr.sort((line1, line2) => {
  const time1 = getTime(line1)
  const time2 = getTime(line2)

  if (time1 < time2) return -1
  if (time1 > time2) return 1
  return 0
})

const maxByVal = map => map.reduce(([maxK, maxV], v, k) => (
  v > maxV ? [k, v] : [maxK, maxV]
), [0, 0])


/*
 * 
 * Main
 * 
*/
const findTimes = ([
  currentEvent,
  nextEvent,
  ...rest
  ],
  currentShift,
  guardTotalTimes = Map(),
  guardMinuteCounts = Map(),
) => {
  if (R.isNil(nextEvent)) { 
    return {
      guardTotalTimes,
      guardMinuteCounts
    }
  }
  const id = getGuard(currentEvent)

  let _currentShift = currentShift
  let _guardTotalTimes = guardTotalTimes
  let _guardMinuteCounts = guardMinuteCounts

  if (id) { _currentShift = id; }

  if (R.includes('asleep', currentEvent)) {
    const start = getMinutes(currentEvent)
    const end = getMinutes(nextEvent)
    const timeAsleep = end - start
    const newTotal = timeAsleep + (_guardTotalTimes.get(_currentShift) || 0)

    _guardTotalTimes = _guardTotalTimes.set(_currentShift, newTotal)

    const minuteArray = R.range(start, end)
    let minuteCounts = _guardMinuteCounts.get(_currentShift) || Map()
    minuteCounts = minuteArray.reduce((counter, min) => {
      const count = counter.get(min) || 0
      return counter.set(min, count + 1)
    }, minuteCounts)

    _guardMinuteCounts = _guardMinuteCounts.set(_currentShift, minuteCounts);
  }

  return findTimes(
    [
      nextEvent,
      ...rest
    ],
    _currentShift,
    _guardTotalTimes,
    _guardMinuteCounts
  )
}

const findSleepiest = ({ guardTotalTimes, guardMinuteCounts }) => {
  const [ sleepiestGuard ] = maxByVal(guardTotalTimes)
  const timeCounts = guardMinuteCounts.get(sleepiestGuard)
  const [ sleepiestMin ] = maxByVal(timeCounts)

  return parseInt(sleepiestGuard) * parseInt(sleepiestMin);
}

const findMostCommonMinute = ({ guardTotalTimes, guardMinuteCounts }) => {
  const accumulater = [null, 0, 0]
  const [ guardId, minute ] = guardMinuteCounts.reduce(([maxId, maxMinute, maxFreq], mins, id) => {
    const [ min, freq ] = maxByVal(mins)
    
    if (freq > maxFreq) {
      return [id, min, freq]
    }
    return [maxId, maxMinute, maxFreq]
  }, accumulater)

  return parseInt(guardId) * parseInt(minute)
}

partOne = R.pipe(
  getLines,
  sortByTime,
  findTimes,
  findSleepiest,
  console.log
)

partTwo = R.pipe(
  getLines,
  sortByTime,
  findTimes,
  findMostCommonMinute,
  console.log
)

partOne('input.txt');
partTwo('input.txt');