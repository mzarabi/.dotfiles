const inContainer = (containerName) => ({ href }) => {
  if (href.includes('file')) {
    href.substr('7')
  }
  `ext+container:name=${containerName}&url=${encodeURIComponent(href)}`;
}

export default {
  defaultBrowser: "Zen",
  rewrite: [
    {
      match: [
        "*fracnordic*",
        "*frac-nordic*",
        "*FRAC-Nordic*",
        "portal.azure.com*",
        "entra.microsoft.com*",
        "file:///*PaloAltoNetworks*",
        "*teams*",
        "*atlassian*",
        "statics.teams"
      ],
      url: inContainer('FRAC')
    },
    {
      match: [
        "*sessionize*",
        "*deltekfirst*",
        "*winningtemp*",
        "*omegapoint*"
      ],
      url: inContainer('OP')
    },
    {
      match: [
        "*reddit*",
        "*youtube*"
      ],
      url: inContainer('MZ')
    }
  ],
}
 