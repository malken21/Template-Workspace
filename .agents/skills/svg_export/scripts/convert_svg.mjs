import { chromium } from 'playwright';
import { fileURLToPath } from 'url';
import path from 'path';
import fs from 'fs';
import { execSync } from 'child_process';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const PROJECT_ROOT = path.resolve(__dirname, '../../../../');
const SOURCE_DIR = path.join(PROJECT_ROOT, 'source');
const DIST_DIR = path.join(PROJECT_ROOT, 'dist');

/**
 * Ensures Playwright Chromium is installed.
 */
function ensurePlaywright() {
    try {
        // Just a check if the package is available (should be via npx -p playwright)
    } catch (e) {
        console.error('[ERROR] Playwright is required. Please run with "npx -p playwright node script.mjs"');
        process.exit(1);
    }
}

/**
 * Gets the dimensions from SVG content.
 */
function getSvgDimensions(svgContent) {
    const widthMatch = svgContent.match(/width="(\d+(\.\d+)?)"/);
    const heightMatch = svgContent.match(/height="(\d+(\.\d+)?)"/);
    const viewBoxMatch = svgContent.match(/viewBox="0 0 (\d+(\.\d+)?) (\d+(\.\d+)?)"/);

    let width = widthMatch ? parseFloat(widthMatch[1]) : null;
    let height = heightMatch ? parseFloat(heightMatch[1]) : null;

    if (!width || !height) {
        if (viewBoxMatch) {
            width = parseFloat(viewBoxMatch[1]);
            height = parseFloat(viewBoxMatch[3]);
        } else {
            // Default fallback
            width = 1920;
            height = 1080;
        }
    }

    return { width, height };
}

/**
 * Converts a single SVG to PNG.
 */
async function convertSvg(browser, svgPath) {
    const fileName = path.basename(svgPath, '.svg');
    const outputPath = path.join(DIST_DIR, `${fileName}.png`);
    const svgRelativePath = path.relative(PROJECT_ROOT, svgPath);
    
    console.log(`[RUN] Converting: ${svgRelativePath} -> ${fileName}.png`);

    const svgContent = fs.readFileSync(svgPath, 'utf-8');
    const dim = getSvgDimensions(svgContent);

    const page = await browser.newPage();
    try {
        // Open file protocol
        const fileUrl = 'file://' + path.resolve(svgPath).replace(/\\/g, '/');
        
        await page.setViewportSize({ width: Math.ceil(dim.width), height: Math.ceil(dim.height) });
        await page.goto(fileUrl, { waitUntil: 'networkidle' });

        // Wait a bit for filters/images to render completely
        await page.waitForTimeout(500);

        await page.screenshot({
            path: outputPath,
            omitBackground: true,
            type: 'png'
        });

        console.log(`[DONE] Success: ${fileName}.png (${dim.width}x${dim.height})`);
    } catch (error) {
        console.error(`[FAIL] ${fileName}: ${error.message}`);
    } finally {
        await page.close();
    }
}

async function main() {
    const args = process.argv.slice(2);
    const isAll = args.includes('--all');
    const targetFile = args.find(a => a.endsWith('.svg'));

    if (!fs.existsSync(DIST_DIR)) {
        fs.mkdirSync(DIST_DIR, { recursive: true });
    }

    const browser = await chromium.launch({
        args: ['--disable-web-security', '--allow-file-access-from-files']
    });

    try {
        if (isAll) {
            const files = fs.readdirSync(SOURCE_DIR).filter(f => f.endsWith('.svg'));
            for (const file of files) {
                await convertSvg(browser, path.join(SOURCE_DIR, file));
            }
        } else if (targetFile) {
            const absolutePath = path.isAbsolute(targetFile) ? targetFile : path.join(process.cwd(), targetFile);
            await convertSvg(browser, absolutePath);
        } else {
            console.log('Usage:');
            console.log('  node convert_svg.mjs --all');
            console.log('  node convert_svg.mjs ./source/file.svg');
        }
    } finally {
        await browser.close();
    }
}

main().catch(err => {
    console.error(err);
    process.exit(1);
});
