import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  template: `
    <mat-toolbar color="primary" class="app-toolbar">
      <mat-icon class="logo">book</mat-icon>
      <span class="app-title">Exploras</span>
      <span class="subtitle">EPUB Knowledge Explorer</span>
    </mat-toolbar>
    
    <div class="app-container">
      <app-epub-explorer></app-epub-explorer>
    </div>
  `,
  styles: [`
    .app-toolbar {
      background: linear-gradient(90deg, #2196F3 0%, #FF9800 100%);
      color: white;
      box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    }
    
    .logo {
      margin-right: 12px;
    }
    
    .app-title {
      font-size: 24px;
      font-weight: 600;
      margin-right: 16px;
    }
    
    .subtitle {
      font-size: 14px;
      opacity: 0.9;
      font-weight: 300;
    }
    
    .app-container {
      min-height: calc(100vh - 64px);
      background: #f5f5f5;
      padding: 20px;
    }
  `]
})
export class AppComponent {
  title = 'Exploras EPUB Explorer';
}
