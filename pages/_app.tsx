import '../styles/globals.css';
import '@rainbow-me/rainbowkit/styles.css';
import type { AppProps } from 'next/app';

import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import {  createConfig, http, WagmiProvider } from 'wagmi';
import {
  arbitrum,
  base,
  mainnet,
  optimism,
  polygon,
  sepolia,
} from 'wagmi/chains';
import { RainbowKitProvider } from '@rainbow-me/rainbowkit';

/*const config = getDefaultConfig({
  appName: 'RainbowKit App',
  projectId: '5d3a851f679de7040ab06519243b5e26',
  chains: [ mainnet, base ],
  ssr: true,
});
*/

const config = createConfig({
  chains: [mainnet, base],
  ssr: true,
  transports: {
    [base.id]: http('https://base-mainnet.g.alchemy.com/v2/F20tu-wfVncdhLHWOAqnekbCDZ5vzE_G'),
    [mainnet.id]: http('https://base-mainnet.g.alchemy.com/v2/F20tu-wfVncdhLHWOAqnekbCDZ5vzE_G'),
  },
})

const client = new QueryClient();

function MyApp({ Component, pageProps }: AppProps) {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={client}>
        <RainbowKitProvider>
          <Component {...pageProps} />
        </RainbowKitProvider>
      </QueryClientProvider>
    </WagmiProvider>
  );
}

export default MyApp;
