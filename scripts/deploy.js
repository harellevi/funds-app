const hre = require('hardhat')
const fs = require('fs')

async function main() {
  //הגדרת העמלה- 5 אחוז מהכסף שנאסף בפרויקט
  const taxFee = 4
  //נמשוך את החוזה החכם
  const Contract = await hre.ethers.getContractFactory('crowdready')
  const contract = await Contract.deploy(taxFee)

  //נבצע העלאה שלו
  await contract.deployed()

  const address = JSON.stringify({ address: contract.address }, null, 4)
  fs.writeFile('./src/abis/contractAddress.json', address, 'utf8', (err) => {
    if (err) {
      console.error(err)
      return
    }
    console.log('Deployed contract address', contract.address)
  })
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
