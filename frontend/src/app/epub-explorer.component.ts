import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../environments/environment';

interface TOCItem {
  id: string;
  title: string;
  href: string;
  level: number;
}

interface QuestionRequest {
  toc_id: string;
  question: string;
}

interface AnswerResponse {
  answer: string;
  context_length: number;
  toc_title: string;
}

@Component({
  selector: 'app-epub-explorer',
  template: `
    <div class="container">
      <!-- Header -->
      <mat-toolbar color="primary">
        <img src="assets/exploras-logo.png" alt="Exploras" class="logo">
        <span>Exploras Agent - EPUB Explorer</span>
      </mat-toolbar>

      <div class="main-content" fxLayout="row" fxLayoutGap="20px">
        
        <!-- TOC Panel -->
        <div fxFlex="30" class="toc-panel">
          <mat-card>
            <mat-card-header>
              <mat-card-title>Table of Contents</mat-card-title>
              <mat-card-subtitle>Select a section to ask questions about</mat-card-subtitle>
            </mat-card-header>
            <mat-card-content>
              <div *ngIf="loading" class="loading">
                <mat-spinner diameter="40"></mat-spinner>
                <p>Loading TOC...</p>
              </div>
              
              <mat-tree [dataSource]="tocDataSource" [treeControl]="treeControl" *ngIf="!loading">
                <mat-tree-node *matTreeNodeDef="let node" matTreeNodePadding>
                  <button mat-button 
                          [class.selected]="selectedTocId === node.id"
                          (click)="selectTocItem(node)">
                    <mat-icon class="toc-icon">article</mat-icon>
                    {{node.title}}
                  </button>
                </mat-tree-node>
              </mat-tree>
            </mat-card-content>
          </mat-card>
        </div>

        <!-- Question & Answer Panel -->
        <div fxFlex="70" class="qa-panel">
          <mat-card>
            <mat-card-header>
              <mat-card-title>Ask a Question</mat-card-title>
              <mat-card-subtitle *ngIf="selectedTocTitle">
                About: {{selectedTocTitle}}
              </mat-card-subtitle>
            </mat-card-header>
            <mat-card-content>
              
              <!-- Question Input -->
              <mat-form-field class="full-width" appearance="outline">
                <mat-label>Your question</mat-label>
                <textarea matInput 
                         [(ngModel)]="question" 
                         rows="3"
                         placeholder="Ask anything about the selected section...">
                </textarea>
              </mat-form-field>

              <div class="actions">
                <button mat-raised-button 
                        color="accent" 
                        (click)="askQuestion()"
                        [disabled]="!selectedTocId || !question.trim() || asking">
                  <mat-icon *ngIf="asking">hourglass_empty</mat-icon>
                  <mat-icon *ngIf="!asking">send</mat-icon>
                  {{asking ? 'Processing...' : 'Ask Question'}}
                </button>
              </div>

              <!-- Answer Display -->
              <div *ngIf="currentAnswer" class="answer-section">
                <mat-divider></mat-divider>
                <h3>Answer</h3>
                <div class="answer-content" markdown [data]="currentAnswer.answer"></div>
                <div class="answer-meta">
                  <mat-chip-set>
                    <mat-chip>Context: {{currentAnswer.context_length}} chars</mat-chip>
                    <mat-chip>Section: {{currentAnswer.toc_title}}</mat-chip>
                  </mat-chip-set>
                </div>
              </div>

            </mat-card-content>
          </mat-card>
        </div>

      </div>
    </div>
  `,
  styles: [`
    .container {
      height: 100vh;
      display: flex;
      flex-direction: column;
    }

    .logo {
      height: 40px;
      margin-right: 10px;
    }

    .main-content {
      flex: 1;
      padding: 20px;
      overflow: hidden;
    }

    .toc-panel, .qa-panel {
      height: calc(100vh - 120px);
      overflow-y: auto;
    }

    .toc-panel mat-card {
      height: 100%;
    }

    .loading {
      text-align: center;
      padding: 20px;
    }

    .toc-icon {
      margin-right: 8px;
    }

    .selected {
      background-color: #e3f2fd !important;
    }

    .full-width {
      width: 100%;
    }

    .actions {
      margin: 16px 0;
    }

    .answer-section {
      margin-top: 20px;
    }

    .answer-content {
      background: #f5f5f5;
      padding: 16px;
      border-radius: 4px;
      margin: 10px 0;
      white-space: pre-wrap;
    }

    .answer-meta {
      margin-top: 10px;
    }

    mat-tree-node button {
      width: 100%;
      text-align: left;
      border: none;
      background: none;
      padding: 8px;
      cursor: pointer;
    }

    mat-tree-node button:hover {
      background-color: #f0f0f0;
    }
  `]
})
export class EpubExplorerComponent implements OnInit {
  tocItems: TOCItem[] = [];
  tocDataSource: any[] = [];
  treeControl: any;
  
  selectedTocId: string = '';
  selectedTocTitle: string = '';
  question: string = '';
  currentAnswer: AnswerResponse | null = null;
  
  loading = true;
  asking = false;

  private apiBaseUrl = environment.apiUrl;

  constructor(private http: HttpClient) {
    // Initialize tree control (simplified - in real app use proper tree control)
  }

  ngOnInit() {
    this.loadToc();
  }

  async loadToc() {
    try {
      this.loading = true;
      const response = await this.http.get<TOCItem[]>(`${this.apiBaseUrl}/toc`).toPromise();
      this.tocItems = response || [];
      this.tocDataSource = this.tocItems;
      this.loading = false;
    } catch (error) {
      console.error('Error loading TOC:', error);
      this.loading = false;
    }
  }

  selectTocItem(item: TOCItem) {
    this.selectedTocId = item.id;
    this.selectedTocTitle = item.title;
    this.currentAnswer = null; // Clear previous answer
  }

  async askQuestion() {
    if (!this.selectedTocId || !this.question.trim()) return;

    try {
      this.asking = true;
      const request: QuestionRequest = {
        toc_id: this.selectedTocId,
        question: this.question.trim()
      };

      const response = await this.http.post<AnswerResponse>(`${this.apiBaseUrl}/question`, request).toPromise();
      this.currentAnswer = response || null;
    } catch (error) {
      console.error('Error asking question:', error);
    } finally {
      this.asking = false;
    }
  }
}
