// Copyright (c) 2022 Espresso Systems (espressosys.com)
//
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

use async_std::prelude::*;
use std::process;
use signal_hook_async_std::Signals;

/// Spawn a thread that waits for SIGTERM. If SIGTERM is received,
/// the application exits with exit status 1.
pub async fn handle_signals(mut signals: Signals) {
    while let Some(signal) = signals.next().await {
        println!("Received signal {:?}", signal);
        process::exit(1);
    }
}
