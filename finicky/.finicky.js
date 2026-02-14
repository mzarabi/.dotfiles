
const ffContainer = (containerName) => ({ href }) => {
  if (href.contains("file")) {
    href = href.substr(7);
  }
  return `ext+container:name=${containerName}&url=${encodeURIComponent(href)}`;
}

export default {
  defaultBrowser: "Zen",
  options: {
    logRequests: true
  },
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
        "*atlassian*"
      ],
      url: ffContainer('FRAC')
    },
    {
      match: [
        "*sessionize*",
        "*deltekfirst*",
        "*winningtemp*",
        "*omegapoint*"
      ],
      url: ffContainer('OP')
    },
    {
      match: [
        "*reddit*",
        "*youtube*"
      ],
      url: ffContainer('MZ')
    }
  ],
}
 